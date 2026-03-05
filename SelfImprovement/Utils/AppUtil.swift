//
//  AppUtil.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation
import UIKit

class AppUtil {
    static let shared = AppUtil()
    
    // iOS 无法监控其他应用的使用时间，这里返回模拟数据
    // 在实际应用中，可能需要使用 Screen Time API 或其他方式
    func loadAllApps(monitoredApps: Set<String>? = nil) -> [AppInfo] {
        let today = DateUtils.shared.getTodayString()
        
        // 模拟应用数据
        let mockApps = [
            AppInfo(appPackageName: "com.tencent.xin", name: "微信", dailyUsageTime: 3600000, isMonitored: monitoredApps?.contains("com.tencent.xin") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.tencent.mqq", name: "QQ", dailyUsageTime: 1800000, isMonitored: monitoredApps?.contains("com.tencent.mqq") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.mobilesafari", name: "Safari", dailyUsageTime: 2700000, isMonitored: monitoredApps?.contains("com.apple.mobilesafari") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.music", name: "音乐", dailyUsageTime: 1200000, isMonitored: monitoredApps?.contains("com.apple.music") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.videos", name: "视频", dailyUsageTime: 4500000, isMonitored: monitoredApps?.contains("com.apple.videos") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.gamecenter", name: "游戏中心", dailyUsageTime: 5400000, isMonitored: monitoredApps?.contains("com.apple.gamecenter") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.weather", name: "天气", dailyUsageTime: 300000, isMonitored: monitoredApps?.contains("com.apple.weather") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.calculator", name: "计算器", dailyUsageTime: 120000, isMonitored: monitoredApps?.contains("com.apple.calculator") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.notes", name: "备忘录", dailyUsageTime: 900000, isMonitored: monitoredApps?.contains("com.apple.notes") ?? false, playAppCurrentTime: today),
            AppInfo(appPackageName: "com.apple.reminders", name: "提醒事项", dailyUsageTime: 600000, isMonitored: monitoredApps?.contains("com.apple.reminders") ?? false, playAppCurrentTime: today)
        ]
        
        // 按使用时间排序
        return mockApps.sorted { $0.dailyUsageTime > $1.dailyUsageTime }
    }
    
    // 获取已监控的应用列表
    func getMonitoredApps() -> [AppInfo] {
        let today = DateUtils.shared.getTodayString()
        let allApps = loadAllApps()
        return allApps.filter { $0.isMonitored }
    }
    
    // 检查是否有权限获取应用使用统计（iOS 中需要特殊权限）
    func hasUsageStatsPermission() -> Bool {
        // iOS 中需要 Screen Time 权限，这里返回 true 作为模拟
        return true
    }
    
    // 请求应用使用统计权限
    func requestUsageStatsPermission() {
        // iOS 中需要引导用户开启 Screen Time 权限
        print("请在设置中开启 Screen Time 权限")
    }
}
