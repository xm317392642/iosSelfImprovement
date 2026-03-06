//
//  DatabaseHelper.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import Foundation
import SQLite3

class DatabaseHelper {
    static let shared = DatabaseHelper()
    
    private var db: OpaquePointer?
    private let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/self_improvement.db")
    
    private init() {
        openDatabase()
        createTables()
    }
    
    private func openDatabase() {
        let status = sqlite3_open(dbPath, &db)
        if status != SQLITE_OK {
            print("Failed to open database: \(status)")
        }
    }
    
    private func createTables() {
        let createHealthStatusTable = """
        CREATE TABLE IF NOT EXISTS health_status (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT UNIQUE,
            health_score REAL,
            entertainment_time INTEGER,
            activity_count INTEGER
        )
        """
        
        let createAppUsageTable = """
        CREATE TABLE IF NOT EXISTS app_usage (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            app_package_name TEXT UNIQUE,
            app_name TEXT,
            daily_usage_time INTEGER,
            date TEXT,
            is_monitored INTEGER
        )
        """
        
        let createActivityRecordTable = """
        CREATE TABLE IF NOT EXISTS activity_record (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            type TEXT,
            date TEXT,
            images TEXT,
            video TEXT,
            location TEXT,
            is_custom INTEGER,
            original_type TEXT,
            created_at REAL
        )
        """
        
        let createVideoRecordTable = """
        CREATE TABLE IF NOT EXISTS video_record (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            video_path TEXT,
            thumbnail_path TEXT,
            date TEXT,
            type TEXT
        )
        """
        
        let createCustomActivityTypeTable = """
        CREATE TABLE IF NOT EXISTS custom_activity_type (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            original_type TEXT,
            icon_path TEXT,
            color TEXT,
            created_at REAL
        )
        """
        
        executeQuery(createHealthStatusTable)
        executeQuery(createAppUsageTable)
        executeQuery(createActivityRecordTable)
        executeQuery(createVideoRecordTable)
        executeQuery(createCustomActivityTypeTable)
    }
    
    private func executeQuery(_ query: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_step(statement)
            sqlite3_finalize(statement)
        } else {
            print("Failed to execute query: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    // MARK: - Health Status
    
    func upsertHealthStatus(_ status: HealthStatus) -> Int64 {
        let query = """
        INSERT OR REPLACE INTO health_status (date, health_score, entertainment_time, activity_count)
        VALUES (?, ?, ?, ?)
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, status.date, -1, nil)
            sqlite3_bind_double(statement, 2, status.healthScore)
            sqlite3_bind_int64(statement, 3, status.entertainmentTime)
            sqlite3_bind_int(statement, 4, Int32(status.activityCount))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                let id = sqlite3_last_insert_rowid(db)
                sqlite3_finalize(statement)
                return id
            }
            sqlite3_finalize(statement)
        }
        return 0
    }
    
    func getHealthStatus(for date: String) -> HealthStatus? {
        let query = "SELECT * FROM health_status WHERE date = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, date, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let date = String(cString: sqlite3_column_text(statement, 1))
                let healthScore = sqlite3_column_double(statement, 2)
                let entertainmentTime = sqlite3_column_int64(statement, 3)
                let activityCount = Int(sqlite3_column_int(statement, 4))
                
                sqlite3_finalize(statement)
                return HealthStatus(date: date, healthScore: healthScore, entertainmentTime: entertainmentTime, activityCount: activityCount)
            }
            sqlite3_finalize(statement)
        }
        return nil
    }
    
    func getAllHealthStatus() -> [HealthStatus] {
        var statuses: [HealthStatus] = []
        let query = "SELECT * FROM health_status ORDER BY date DESC"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let date = String(cString: sqlite3_column_text(statement, 1))
                let healthScore = sqlite3_column_double(statement, 2)
                let entertainmentTime = sqlite3_column_int64(statement, 3)
                let activityCount = Int(sqlite3_column_int(statement, 4))
                
                let status = HealthStatus(date: date, healthScore: healthScore, entertainmentTime: entertainmentTime, activityCount: activityCount)
                statuses.append(status)
            }
            sqlite3_finalize(statement)
        }
        return statuses
    }
    
    // MARK: - App Usage
    
    func upsertAppUsage(_ appInfo: AppInfo) -> Int64 {
        let query = """
        INSERT OR REPLACE INTO app_usage (app_package_name, app_name, daily_usage_time, date, is_monitored)
        VALUES (?, ?, ?, ?, ?)
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, appInfo.appPackageName, -1, nil)
            sqlite3_bind_text(statement, 2, appInfo.name, -1, nil)
            sqlite3_bind_int64(statement, 3, appInfo.dailyUsageTime)
            sqlite3_bind_text(statement, 4, appInfo.playAppCurrentTime, -1, nil)
            sqlite3_bind_int(statement, 5, appInfo.isMonitored ? 1 : 0)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                let id = sqlite3_last_insert_rowid(db)
                sqlite3_finalize(statement)
                return id
            }
            sqlite3_finalize(statement)
        }
        return 0
    }
    
    func getAppUsageList(isMonitored: Bool? = nil, queryTime: String) -> [AppInfo] {
        var apps: [AppInfo] = []
        var query: String
        
        if let isMonitored = isMonitored {
            query = "SELECT app_package_name, app_name, daily_usage_time, date, is_monitored FROM app_usage WHERE date = ? AND is_monitored = ?"
        } else {
            query = "SELECT app_package_name, app_name, daily_usage_time, date, is_monitored FROM app_usage WHERE date = ?"
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, queryTime, -1, nil)
            if let isMonitored = isMonitored {
                sqlite3_bind_int(statement, 2, isMonitored ? 1 : 0)
            }
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let appPackageName = String(cString: sqlite3_column_text(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let dailyUsageTime = sqlite3_column_int64(statement, 2)
                let date = String(cString: sqlite3_column_text(statement, 3))
                let isMonitored = sqlite3_column_int(statement, 4) == 1
                
                let appInfo = AppInfo(appPackageName: appPackageName, name: name, dailyUsageTime: dailyUsageTime, isMonitored: isMonitored, playAppCurrentTime: date)
                apps.append(appInfo)
            }
            sqlite3_finalize(statement)
        }
        return apps
    }
    
    func batchUpsertAppUsage(_ apps: [AppInfo]) -> Int {
        var count = 0
        for app in apps {
            if upsertAppUsage(app) > 0 {
                count += 1
            }
        }
        return count
    }
    
    func getTodayMonitoredAppsTotalUsageTime() -> Int64 {
        let today = Date().toString(format: "yyyy-MM-dd")
        let query = "SELECT SUM(daily_usage_time) FROM app_usage WHERE date = ? AND is_monitored = 1"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, today, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let totalTime = sqlite3_column_int64(statement, 0)
                sqlite3_finalize(statement)
                return totalTime
            }
            sqlite3_finalize(statement)
        }
        return 0
    }
    
    // MARK: - Activity Record
    
    func insertActivityRecord(_ record: ActivityRecord) -> Int64 {
        let imagesJSON = try? JSONEncoder().encode(record.images)
        let imagesString = imagesJSON != nil ? String(data: imagesJSON!, encoding: .utf8) : nil
        
        let query = """
        INSERT INTO activity_record (title, content, type, date, images, video, location, is_custom, original_type, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, record.title, -1, nil)
            sqlite3_bind_text(statement, 2, record.content, -1, nil)
            sqlite3_bind_text(statement, 3, record.type, -1, nil)
            sqlite3_bind_text(statement, 4, record.date, -1, nil)
            sqlite3_bind_text(statement, 5, imagesString, -1, nil)
            sqlite3_bind_text(statement, 6, record.video, -1, nil)
            sqlite3_bind_text(statement, 7, record.location, -1, nil)
            sqlite3_bind_int(statement, 8, record.isCustom ? 1 : 0)
            sqlite3_bind_text(statement, 9, record.originalType, -1, nil)
            sqlite3_bind_double(statement, 10, record.createdAt)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                let id = sqlite3_last_insert_rowid(db)
                sqlite3_finalize(statement)
                return id
            }
            sqlite3_finalize(statement)
        }
        return 0
    }
    
    func getActivityRecordsByType(_ type: String, date: String) -> [ActivityRecord] {
        var records: [ActivityRecord] = []
        let query = "SELECT * FROM activity_record WHERE type = ? AND date = ? ORDER BY created_at DESC"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, type, -1, nil)
            sqlite3_bind_text(statement, 2, date, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let title = String(cString: sqlite3_column_text(statement, 1))
                let content = String(cString: sqlite3_column_text(statement, 2))
                let type = String(cString: sqlite3_column_text(statement, 3))
                let date = String(cString: sqlite3_column_text(statement, 4))
                
                var images: [String]?
                if let imagesData = sqlite3_column_text(statement, 5) {
                    let imagesString = String(cString: imagesData)
                    images = try? JSONDecoder().decode([String].self, from: imagesString.data(using: .utf8)!)
                }
                
                var video: String?
                if let videoData = sqlite3_column_text(statement, 6) {
                    video = String(cString: videoData)
                }
                
                var location: String?
                if let locationData = sqlite3_column_text(statement, 7) {
                    location = String(cString: locationData)
                }
                
                let isCustom = sqlite3_column_int(statement, 8) == 1
                
                var originalType: String?
                if let originalTypeData = sqlite3_column_text(statement, 9) {
                    originalType = String(cString: originalTypeData)
                }
                
                let createdAt = sqlite3_column_double(statement, 10)
                
                var record = ActivityRecord(title: title, content: content, type: type, date: date)
                record.id = id
                record.images = images
                record.video = video
                record.location = location
                record.isCustom = isCustom
                record.originalType = originalType
                record.createdAt = createdAt
                
                records.append(record)
            }
            sqlite3_finalize(statement)
        }
        return records
    }
    
    func getAllActivityRecords() -> [ActivityRecord] {
        var records: [ActivityRecord] = []
        let query = "SELECT * FROM activity_record ORDER BY created_at DESC"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let title = String(cString: sqlite3_column_text(statement, 1))
                let content = String(cString: sqlite3_column_text(statement, 2))
                let type = String(cString: sqlite3_column_text(statement, 3))
                let date = String(cString: sqlite3_column_text(statement, 4))
                
                var images: [String]?
                if let imagesData = sqlite3_column_text(statement, 5) {
                    let imagesString = String(cString: imagesData)
                    images = try? JSONDecoder().decode([String].self, from: imagesString.data(using: .utf8)!)
                }
                
                var video: String?
                if let videoData = sqlite3_column_text(statement, 6) {
                    video = String(cString: videoData)
                }
                
                var location: String?
                if let locationData = sqlite3_column_text(statement, 7) {
                    location = String(cString: locationData)
                }
                
                let isCustom = sqlite3_column_int(statement, 8) == 1
                
                var originalType: String?
                if let originalTypeData = sqlite3_column_text(statement, 9) {
                    originalType = String(cString: originalTypeData)
                }
                
                let createdAt = sqlite3_column_double(statement, 10)
                
                var record = ActivityRecord(title: title, content: content, type: type, date: date)
                record.id = id
                record.images = images
                record.video = video
                record.location = location
                record.isCustom = isCustom
                record.originalType = originalType
                record.createdAt = createdAt
                
                records.append(record)
            }
            sqlite3_finalize(statement)
        }
        return records
    }
    
    // MARK: - Video Record
    
    func insertVideoRecord(_ record: VideoRecord) -> Int64 {
        let query = """
        INSERT INTO video_record (title, video_path, thumbnail_path, date, type)
        VALUES (?, ?, ?, ?, ?)
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, record.title, -1, nil)
            sqlite3_bind_text(statement, 2, record.videoPath, -1, nil)
            sqlite3_bind_text(statement, 3, record.thumbnailPath, -1, nil)
            sqlite3_bind_text(statement, 4, record.date, -1, nil)
            sqlite3_bind_text(statement, 5, record.type, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                let id = sqlite3_last_insert_rowid(db)
                sqlite3_finalize(statement)
                return id
            }
            sqlite3_finalize(statement)
        }
        return 0
    }
    
    func getVideoRecordsByType(_ type: String, date: String) -> [VideoRecord] {
        var records: [VideoRecord] = []
        let query = "SELECT * FROM video_record WHERE type = ? AND date = ?"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, type, -1, nil)
            sqlite3_bind_text(statement, 2, date, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let title = String(cString: sqlite3_column_text(statement, 1))
                let videoPath = String(cString: sqlite3_column_text(statement, 2))
                let thumbnailPath = String(cString: sqlite3_column_text(statement, 3))
                let date = String(cString: sqlite3_column_text(statement, 4))
                let type = String(cString: sqlite3_column_text(statement, 5))
                
                var record = VideoRecord(title: title, videoPath: videoPath, thumbnailPath: thumbnailPath, date: date, type: type)
                record.id = id
                records.append(record)
            }
            sqlite3_finalize(statement)
        }
        return records
    }
    
    // MARK: - Custom Activity Type
    
    func addCustomActivityType(_ type: CustomActivityType) -> Int64 {
        let query = """
        INSERT OR REPLACE INTO custom_activity_type (name, original_type, icon_path, color, created_at)
        VALUES (?, ?, ?, ?, ?)
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, type.name, -1, nil)
            
            if let originalType = type.originalType {
                sqlite3_bind_text(statement, 2, originalType, -1, nil)
            } else {
                sqlite3_bind_null(statement, 2)
            }
            
            if let iconPath = type.iconPath {
                sqlite3_bind_text(statement, 3, iconPath, -1, nil)
            } else {
                sqlite3_bind_null(statement, 3)
            }
            
            sqlite3_bind_text(statement, 4, type.color, -1, nil)
            sqlite3_bind_double(statement, 5, type.createdAt)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                let id = sqlite3_last_insert_rowid(db)
                sqlite3_finalize(statement)
                return id
            }
            sqlite3_finalize(statement)
        }
        return 0
    }
    
    func getAllCustomActivityTypes() -> [CustomActivityType] {
        var types: [CustomActivityType] = []
        let query = "SELECT * FROM custom_activity_type ORDER BY created_at DESC"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let name = String(cString: sqlite3_column_text(statement, 1))
                
                var originalType: String?
                if let originalTypeData = sqlite3_column_text(statement, 2) {
                    originalType = String(cString: originalTypeData)
                }
                
                var iconPath: String?
                if let iconPathData = sqlite3_column_text(statement, 3) {
                    iconPath = String(cString: iconPathData)
                }
                
                let color = String(cString: sqlite3_column_text(statement, 4))
                let createdAt = sqlite3_column_double(statement, 5)
                
                var customType = CustomActivityType(name: name, color: color)
                customType.id = id
                customType.originalType = originalType
                customType.iconPath = iconPath
                customType.createdAt = createdAt
                
                types.append(customType)
            }
            sqlite3_finalize(statement)
        }
        return types
    }
    
    func deleteCustomActivityType(id: Int64) -> Bool {
        let query = "DELETE FROM custom_activity_type WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, id)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            }
            sqlite3_finalize(statement)
        }
        return false
    }
    
    func getTodayPositiveActivityCount() -> Int {
        let today = Date().toString(format: "yyyy-MM-dd")
        let query = "SELECT COUNT(*) FROM activity_record WHERE date = ?"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, today, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let count = Int(sqlite3_column_int(statement, 0))
                sqlite3_finalize(statement)
                return count
            }
            sqlite3_finalize(statement)
        }
        return 0
    }
}

// MARK: - Date Extension

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
