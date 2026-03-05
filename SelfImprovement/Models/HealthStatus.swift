//
//  HealthStatus.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

struct HealthStatus: Codable, Identifiable {
    var id: Int64 = 0
    var date: String
    var healthScore: Double
    var entertainmentTime: Int64
    var activityCount: Int
    
    init(date: String, healthScore: Double, entertainmentTime: Int64, activityCount: Int) {
        self.date = date
        self.healthScore = healthScore
        self.entertainmentTime = entertainmentTime
        self.activityCount = activityCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case healthScore
        case entertainmentTime
        case activityCount
    }
}
