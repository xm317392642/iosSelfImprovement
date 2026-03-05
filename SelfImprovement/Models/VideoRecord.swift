//
//  VideoRecord.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

struct VideoRecord: Codable, Identifiable {
    var id: Int64 = 0
    var title: String
    var videoPath: String
    var thumbnailPath: String
    var date: String
    var type: String
    
    init(title: String, videoPath: String, thumbnailPath: String, date: String, type: String) {
        self.title = title
        self.videoPath = videoPath
        self.thumbnailPath = thumbnailPath
        self.date = date
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case videoPath
        case thumbnailPath
        case date
        case type
    }
}
