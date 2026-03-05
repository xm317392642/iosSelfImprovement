//
//  DateUtils.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

class DateUtils {
    static let shared = DateUtils()
    
    private let formatter = DateFormatter()
    
    func getTodayString() -> String {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func getDateString(_ date: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getDateTimeString(_ date: Date) -> String {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func parseDate(_ dateString: String) -> Date? {
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
    
    func getStartOfDay(_ date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: date)
    }
    
    func getEndOfDay(_ date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var components = DateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(byAdding: components, to: getStartOfDay(date))!
    }
    
    func getDaysBetween(_ startDate: Date, _ endDate: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day ?? 0
    }
    
    func getPreviousDays(count: Int) -> [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        
        for i in 0..<count {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            dates.append(getDateString(date))
        }
        
        return dates
    }
    
    func formatTimeInterval(_ milliseconds: Int64) -> String {
        let seconds = milliseconds / 1000
        let minutes = seconds / 60
        let hours = minutes / 60
        
        if hours > 0 {
            return "\(hours)小时\(minutes % 60)分钟"
        } else if minutes > 0 {
            return "\(minutes)分钟"
        } else {
            return "\(seconds)秒"
        }
    }
}
