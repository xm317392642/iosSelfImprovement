//
//  AppUsageRepository.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

class AppUsageRepository {
    static let shared = AppUsageRepository()
    private let dbHelper = DatabaseHelper.shared
    
    func addMonitoredApp(_ appInfo: AppInfo) -> Int64 {
        var updatedApp = appInfo
        updatedApp.isMonitored = true
        return dbHelper.upsertAppUsage(updatedApp)
    }
    
    func removeMonitoredApp(_ appInfo: AppInfo) -> Int64 {
        var updatedApp = appInfo
        updatedApp.isMonitored = false
        return dbHelper.upsertAppUsage(updatedApp)
    }
    
    func batchUpdateAppUsage(_ apps: [AppInfo]) -> Int {
        let result = dbHelper.batchUpsertAppUsage(apps)
        
        // 计算并更新总娱乐时间
        updateTotalEntertainmentTime()
        
        return result
    }
    
    func getTodayMonitoredAppsTotalUsageTime() -> Int64 {
        // 从 MMKV 获取娱乐时间
        let entertainmentTimeMinutes = MMKVUtil.shared.getInt("entertainment_time", 0)
        return Int64(entertainmentTimeMinutes) * 60 * 1000 // 转换为毫秒
    }
    
    func getMonitoredApps() -> [AppInfo] {
        let today = DateUtils.shared.getTodayString()
        return dbHelper.getAppUsageList(isMonitored: true, queryTime: today)
    }
    
    private func updateTotalEntertainmentTime() {
        // 从数据库获取总娱乐时间（分钟）
        let totalMinutes = dbHelper.getTodayMonitoredAppsTotalUsageTime() / (1000 * 60)
        // 存储到 MMKV
        MMKVUtil.shared.putInt("entertainment_time", Int(totalMinutes))
    }
}

