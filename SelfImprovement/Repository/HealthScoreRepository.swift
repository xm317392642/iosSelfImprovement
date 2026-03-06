//
//  HealthScoreRepository.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

class HealthScoreRepository {
    static let shared = HealthScoreRepository()
    private let dbHelper = DatabaseHelper.shared
    private let calculator = HealthValueCalculator.shared
    
    func updateHealthScore() -> Double {
        let today = DateUtils.shared.getTodayString()
        // 从 MMKV 获取娱乐时间
        let entertainmentTimeMinutes = MMKVUtil.shared.getInt("entertainment_time", 0)
        let entertainmentTime = Int64(entertainmentTimeMinutes) * 60 * 1000 // 转换为毫秒
        let activityCount = ActivityRecordRepository.shared.getTodayActivityCount()
        
        let healthScore = calculator.calculateHealthValue(entertainmentTime: entertainmentTime, activityCount: activityCount)
        
        let healthStatus = HealthStatus(date: today, healthScore: healthScore, entertainmentTime: entertainmentTime, activityCount: activityCount)
        dbHelper.upsertHealthStatus(healthStatus)
        
        // 存储健康值到 MMKV
        MMKVUtil.shared.putFloat("health_value", Float(healthScore))
        
        // 更新满分天数
        updatePerfectScoreCount(healthScore: healthScore)
        
        return healthScore
    }
    
    func getTodayHealthScore() -> Double {
        let today = DateUtils.shared.getTodayString()
        if let status = dbHelper.getHealthStatus(for: today) {
            return status.healthScore
        }
        return updateHealthScore()
    }
    
    func getHealthStatus(for date: String) -> HealthStatus? {
        return dbHelper.getHealthStatus(for: date)
    }
    
    func getAllHealthStatus() -> [HealthStatus] {
        return dbHelper.getAllHealthStatus()
    }
    
    func getHundredScoreDaysCount() -> Int {
        // 从 MMKV 获取满分天数
        return MMKVUtil.shared.getInt("perfect_score_count", 0)
    }
    
    private func updatePerfectScoreCount(healthScore: Double) {
        let today = DateUtils.shared.getTodayString()
        let perfectScoreKey = "perfect_score_\(today)"
        
        // 检查今天是否已经记录过满分
        if healthScore == 100.0 && !MMKVUtil.shared.getBoolean(perfectScoreKey, false) {
            // 增加满分天数
            let currentCount = MMKVUtil.shared.getInt("perfect_score_count", 0)
            MMKVUtil.shared.putInt("perfect_score_count", currentCount + 1)
            // 标记今天已经记录过满分
            MMKVUtil.shared.putBoolean(perfectScoreKey, true)
        }
    }
}

