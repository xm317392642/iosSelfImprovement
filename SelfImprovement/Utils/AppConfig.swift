//
//  AppConfig.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  应用配置常量
//

import Foundation

struct AppConfig {
    static let BASE_HEALTH_SCORE: Double = 80.0
    static let ENTERTAINMENT_TIME_PENALTY: Double = 5.0
    static let POSITIVE_ACTIVITY_BONUS: Double = 5.0
    
    static let EVENT_SCORE_CHANGED = "EVENT_SCORE_CHANGED"
    static let EVENT_REFRESH_MONITORED_APPS = "EVENT_REFRESH_MONITORED_APPS"
    static let EVENT_REFRESH_HOME_DATA = "EVENT_REFRESH_HOME_DATA"
    static let EVENT_AVATAR_UPDATED = "EVENT_AVATAR_UPDATED"
    static let EVENT_REFRESH_PUBLISH_COUNTS = "EVENT_REFRESH_PUBLISH_COUNTS"
    
    static let HEALTH_VALUE_EXCELLENT_MIN = 90
    static let HEALTH_VALUE_GOOD_MIN = 80
    static let HEALTH_VALUE_POOR_MIN = 60
    static let HEALTH_VALUE_CRITICAL_MIN = 30
    
    static let MAX_PHOTO_DIMENSION: CGFloat = 1024
    static let THUMBNAIL_SIZE: CGFloat = 200
    
    static let DEFAULT_ACTIVITY_TYPES = [
        "学习", "运动", "阅读", "工作", "其他",
        "跑步", "唱歌", "演讲", "脱口秀", "颈椎操"
    ]
}
