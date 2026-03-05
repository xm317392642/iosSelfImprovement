//
//  HealthValueCalculator.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

class HealthValueCalculator {
    static let shared = HealthValueCalculator()
    
    private let baseScore: Double = 80.0
    private let activityScore: Double = 5.0
    private let entertainmentScorePer30Minutes: Double = 5.0
    
    func calculateHealthValue(entertainmentTime: Int64, activityCount: Int) -> Double {
        // 基础分数
        var score = baseScore
        
        // 正向活动加分
        score += Double(activityCount) * activityScore
        
        // 娱乐时间减分（每30分钟减5分）
        let entertainmentHours = Double(entertainmentTime) / (1000.0 * 60.0 * 30.0)
        let entertainmentPenalty = min(80.0, entertainmentHours * entertainmentScorePer30Minutes)
        score -= entertainmentPenalty
        
        // 确保分数在0-100之间
        score = max(0.0, min(100.0, score))
        
        return score
    }
    
    func getHealthLevel(score: Double) -> String {
        switch score {
        case 90...100:
            return "优秀"
        case 80..<90:
            return "良好"
        case 60..<80:
            return "一般"
        case 30..<60:
            return "较差"
        default:
            return "危急"
        }
    }
    
    func getHealthColor(score: Double) -> UIColor {
        switch score {
        case 90...100:
            return UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0) // 绿色
        case 80..<90:
            return UIColor(red: 0.42, green: 0.78, blue: 0.44, alpha: 1.0) // 浅绿色
        case 60..<80:
            return UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0) // 黄色
        case 30..<60:
            return UIColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.0) // 橙色
        default:
            return UIColor(red: 0.85, green: 0.20, blue: 0.20, alpha: 1.0) // 红色
        }
    }
}
