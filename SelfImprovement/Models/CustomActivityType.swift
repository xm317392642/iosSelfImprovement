//
//  CustomActivityType.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  自定义活动类型模型
//

import Foundation

struct CustomActivityType: Codable {
    var id: Int64 = 0
    var name: String
    var originalType: String?
    var iconPath: String?
    var color: String
    var createdAt: TimeInterval = Date().timeIntervalSince1970
    
    init(name: String, color: String = "#4CAF50") {
        self.name = name
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalType
        case iconPath
        case color
        case createdAt
    }
}
