//
//  AppDelegate.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BackgroundTaskManager.shared.registerBackgroundTasks()
        BackgroundTaskManager.shared.scheduleHealthScoreUpdate()
        BackgroundTaskManager.shared.scheduleDailySummary()
        
        _ = DatabaseHelper.shared
        
        // 初始化 MMKV 数据
        initializeMMKVData()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BackgroundTaskManager.shared.scheduleHealthScoreUpdate()
        BackgroundTaskManager.shared.scheduleDailySummary()
    }
    
    private func initializeMMKVData() {
        // 检查首次使用时间
        if MMKVUtil.shared.getStringOrNull("first_use_time_with_time") == nil {
            let currentTime = DateUtils.shared.getCurrentTimeString()
            MMKVUtil.shared.putString("first_use_time_with_time", currentTime)
        }
        
        // 检查默认用户名
        if MMKVUtil.shared.getStringOrNull("user_nickname") == nil {
            MMKVUtil.shared.putString("user_nickname", "用户")
        }
        
        // 初始化其他默认值
        if MMKVUtil.shared.getInt("perfect_score_count", 0) == 0 {
            MMKVUtil.shared.putInt("perfect_score_count", 0)
        }
        
        if MMKVUtil.shared.getInt("entertainment_time", 0) == 0 {
            MMKVUtil.shared.putInt("entertainment_time", 0)
        }
    }
}

