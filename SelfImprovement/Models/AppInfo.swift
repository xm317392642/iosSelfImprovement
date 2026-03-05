//
//  AppInfo.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

struct AppInfo: Codable, Identifiable {
    var id: String { appPackageName }
    var appPackageName: String
    var name: String
    var dailyUsageTime: Int64
    var isMonitored: Bool
    var playAppCurrentTime: String
    
    init(appPackageName: String, name: String, dailyUsageTime: Int64, isMonitored: Bool, playAppCurrentTime: String) {
        self.appPackageName = appPackageName
        self.name = name
        self.dailyUsageTime = dailyUsageTime
        self.isMonitored = isMonitored
        self.playAppCurrentTime = playAppCurrentTime
    }
    
    enum CodingKeys: String, CodingKey {
        case appPackageName
        case name
        case dailyUsageTime
        case isMonitored
        case playAppCurrentTime
    }
}
