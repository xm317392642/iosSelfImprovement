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
        let entertainmentTime = AppUsageRepository.shared.getTodayMonitoredAppsTotalUsageTime()
        let activityCount = ActivityRecordRepository.shared.getTodayActivityCount()
        
        let healthScore = calculator.calculateHealthValue(entertainmentTime: entertainmentTime, activityCount: activityCount)
        
        let healthStatus = HealthStatus(date: today, healthScore: healthScore, entertainmentTime: entertainmentTime, activityCount: activityCount)
        dbHelper.upsertHealthStatus(healthStatus)
        
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
        let statuses = dbHelper.getAllHealthStatus()
        return statuses.filter { $0.healthScore == 100.0 }.count
    }
}
