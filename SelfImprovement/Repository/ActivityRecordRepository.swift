//
//  ActivityRecordRepository.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation

class ActivityRecordRepository {
    static let shared = ActivityRecordRepository()
    private let dbHelper = DatabaseHelper.shared
    
    func addActivityRecord(_ record: ActivityRecord) -> Int64 {
        return dbHelper.insertActivityRecord(record)
    }
    
    func getActivityRecordsByType(_ type: String, date: String) -> [ActivityRecord] {
        return dbHelper.getActivityRecordsByType(type, date: date)
    }
    
    func getAllActivityRecords() -> [ActivityRecord] {
        return dbHelper.getAllActivityRecords()
    }
    
    func getTodayActivityCount() -> Int {
        let today = DateUtils.shared.getTodayString()
        let records = dbHelper.getAllActivityRecords()
        return records.filter { $0.date == today }.count
    }
}
