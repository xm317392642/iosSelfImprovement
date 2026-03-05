//
//  MotivationalQuotesUtil.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

class MotivationalQuotesUtil {
    static let shared = MotivationalQuotesUtil()
    
    private let quotes = [
        "掌控时间，提升自我",
        "记录每一步成长",
        "健康生活，从管理时间开始",
        "正向活动，成就更好的自己",
        "每天进步一点点",
        "时间是最宝贵的财富",
        "自律是成功的关键",
        "坚持是胜利的保证",
        "每一次努力都值得记录",
        "做最好的自己",
        "今天的你比昨天更优秀",
        "行动是成功的开始",
        "梦想需要行动来实现",
        "专注当下，成就未来",
        "小目标，大成就"
    ]
    
    func getRandomQuote() -> String {
        let randomIndex = Int.random(in: 0..<quotes.count)
        return quotes[randomIndex]
    }
}
