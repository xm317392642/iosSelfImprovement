//
//  ActivityRecord.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

struct ActivityRecord: Codable, Identifiable {
    var id: Int64 = 0
    var title: String
    var content: String
    var type: String
    var date: String
    var images: [String]?
    var video: String?
    var location: String?
    var isCustom: Bool = false
    var originalType: String?
    var createdAt: TimeInterval = Date().timeIntervalSince1970
    
    init(title: String, content: String, type: String, date: String) {
        self.title = title
        self.content = content
        self.type = type
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case type
        case date
        case images
        case video
        case location
        case isCustom
        case originalType
        case createdAt
    }
}
