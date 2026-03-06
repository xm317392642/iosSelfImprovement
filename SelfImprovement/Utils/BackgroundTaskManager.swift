//
//  BackgroundTaskManager.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  后台任务管理器
//

import UIKit
import BackgroundTasks

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    private let healthScoreTaskIdentifier = "com.selfimprovement.healthscore.update"
    private let dailySummaryTaskIdentifier = "com.selfimprovement.dailysummary.update"
    
    private init() {}
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: healthScoreTaskIdentifier, using: nil) { task in
            self.handleHealthScoreTask(task: task as! BGAppRefreshTask)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: dailySummaryTaskIdentifier, using: nil) { task in
            self.handleDailySummaryTask(task: task as! BGProcessingTask)
        }
    }
    
    func scheduleHealthScoreUpdate() {
        let request = BGAppRefreshTaskRequest(identifier: healthScoreTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Health score update task scheduled")
        } catch {
            print("Could not schedule health score update task: \(error)")
        }
    }
    
    func scheduleDailySummary() {
        let request = BGProcessingTaskRequest(identifier: dailySummaryTaskIdentifier)
        request.earliestBeginDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: Date())
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Daily summary task scheduled")
        } catch {
            print("Could not schedule daily summary task: \(error)")
        }
    }
    
    private func handleHealthScoreTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        DispatchQueue.global().async {
            self.calculateAndSaveHealthScore()
            
            DispatchQueue.main.async {
                task.setTaskCompleted(success: true)
            }
        }
        
        scheduleHealthScoreUpdate()
    }
    
    private func handleDailySummaryTask(task: BGProcessingTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        DispatchQueue.global().async {
            self.generateDailySummary()
            
            DispatchQueue.main.async {
                task.setTaskCompleted(success: true)
            }
        }
        
        scheduleDailySummary()
    }
    
    private func calculateAndSaveHealthScore() {
        let dbHelper = DatabaseHelper.shared
        
        let entertainmentTime = dbHelper.getTodayMonitoredAppsTotalUsageTime()
        let activityCount = dbHelper.getTodayPositiveActivityCount()
        
        let healthScore = HealthValueCalculator.shared.calculateHealthValue(
            entertainmentTime: entertainmentTime,
            activityCount: activityCount
        )
        
        let today = DateUtils.shared.getTodayString()
        let status = HealthStatus(
            date: today,
            healthScore: healthScore,
            entertainmentTime: entertainmentTime,
            activityCount: activityCount
        )
        
        dbHelper.upsertHealthStatus(status)
        
        DispatchQueue.main.async {
            EventCenter.shared.post(AppConfig.EVENT_SCORE_CHANGED, value: Int(healthScore))
        }
        
        print("Health score calculated: \(healthScore)")
    }
    
    private func generateDailySummary() {
        let dbHelper = DatabaseHelper.shared
        
        let entertainmentTime = dbHelper.getTodayMonitoredAppsTotalUsageTime()
        let activityCount = dbHelper.getTodayPositiveActivityCount()
        
        let healthScore = HealthValueCalculator.shared.calculateHealthValue(
            entertainmentTime: entertainmentTime,
            activityCount: activityCount
        )
        
        let today = DateUtils.shared.getTodayString()
        let status = HealthStatus(
            date: today,
            healthScore: healthScore,
            entertainmentTime: entertainmentTime,
            activityCount: activityCount
        )
        
        dbHelper.upsertHealthStatus(status)
        
        DispatchQueue.main.async {
            EventCenter.shared.post(AppConfig.EVENT_SCORE_CHANGED, value: Int(healthScore))
            EventCenter.shared.post(AppConfig.EVENT_REFRESH_HOME_DATA, value: true)
        }
        
        print("Daily summary generated for \(today)")
    }
}
