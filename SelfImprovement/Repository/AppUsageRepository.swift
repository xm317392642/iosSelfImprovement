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
        return dbHelper.batchUpsertAppUsage(apps)
    }
    
    func getTodayMonitoredAppsTotalUsageTime() -> Int64 {
        return dbHelper.getTodayMonitoredAppsTotalUsageTime()
    }
    
    func getMonitoredApps() -> [AppInfo] {
        let today = DateUtils.shared.getTodayString()
        return dbHelper.getAppUsageList(isMonitored: true, queryTime: today)
    }
}
