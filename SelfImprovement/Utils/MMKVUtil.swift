//
//  MMKVUtil.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//

import Foundation

class MMKVUtil {
    static let shared = MMKVUtil()
    private var userDefaultsMap: [String: UserDefaults] = [:]
    
    private init() {
        // 初始化
    }
    
    /**
     * 获取默认的 UserDefaults 实例
     */
    private func getMMKV() -> UserDefaults {
        return UserDefaults.standard
    }
    
    /**
     * 获取指定ID的 UserDefaults 实例
     * @param id 实例ID
     */
    private func getMMKV(id: String) -> UserDefaults {
        if let userDefaults = userDefaultsMap[id] {
            return userDefaults
        } else {
            let suiteName = "com.self.improvement.\(id)"
            let userDefaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
            userDefaultsMap[id] = userDefaults
            return userDefaults
        }
    }
    
    // 存储字符串
    func putString(_ key: String, _ value: String) {
        getMMKV().set(value, forKey: key)
        getMMKV().synchronize()
    }
    
    // 存储字符串，使用指定ID的实例
    func putString(id: String, key: String, value: String) {
        getMMKV(id: id).set(value, forKey: key)
        getMMKV(id: id).synchronize()
    }
    
    // 获取字符串
    func getString(_ key: String, _ defaultValue: String = "") -> String {
        return getMMKV().string(forKey: key) ?? defaultValue
    }
    
    // 获取字符串（可选）
    func getStringOrNull(_ key: String) -> String? {
        return getMMKV().string(forKey: key)
    }
    
    // 获取字符串，使用指定ID的实例
    func getString(id: String, key: String, defaultValue: String = "") -> String {
        return getMMKV(id: id).string(forKey: key) ?? defaultValue
    }
    
    // 获取字符串（可选），使用指定ID的实例
    func getStringOrNull(id: String, key: String) -> String? {
        return getMMKV(id: id).string(forKey: key)
    }
    
    // 存储整数
    func putInt(_ key: String, _ value: Int) {
        getMMKV().set(value, forKey: key)
        getMMKV().synchronize()
    }
    
    // 存储整数，使用指定ID的实例
    func putInt(id: String, key: String, value: Int) {
        getMMKV(id: id).set(value, forKey: key)
        getMMKV(id: id).synchronize()
    }
    
    // 获取整数
    func getInt(_ key: String, _ defaultValue: Int = 0) -> Int {
        return getMMKV().integer(forKey: key)
    }
    
    // 获取整数，使用指定ID的实例
    func getInt(id: String, key: String, defaultValue: Int = 0) -> Int {
        return getMMKV(id: id).integer(forKey: key)
    }
    
    // 存储长整数
    func putLong(_ key: String, _ value: Int64) {
        getMMKV().set(value, forKey: key)
        getMMKV().synchronize()
    }
    
    // 存储长整数，使用指定ID的实例
    func putLong(id: String, key: String, value: Int64) {
        getMMKV(id: id).set(value, forKey: key)
        getMMKV(id: id).synchronize()
    }
    
    // 获取长整数
    func getLong(_ key: String, _ defaultValue: Int64 = 0) -> Int64 {
        return getMMKV().integer(forKey: key)
    }
    
    // 获取长整数，使用指定ID的实例
    func getLong(id: String, key: String, defaultValue: Int64 = 0) -> Int64 {
        return getMMKV(id: id).integer(forKey: key)
    }
    
    // 存储浮点数
    func putFloat(_ key: String, _ value: Float) {
        getMMKV().set(value, forKey: key)
        getMMKV().synchronize()
    }
    
    // 存储浮点数，使用指定ID的实例
    func putFloat(id: String, key: String, value: Float) {
        getMMKV(id: id).set(value, forKey: key)
        getMMKV(id: id).synchronize()
    }
    
    // 获取浮点数
    func getFloat(_ key: String, _ defaultValue: Float = 0.0) -> Float {
        return getMMKV().float(forKey: key)
    }
    
    // 获取浮点数，使用指定ID的实例
    func getFloat(id: String, key: String, defaultValue: Float = 0.0) -> Float {
        return getMMKV(id: id).float(forKey: key)
    }
    
    // 存储双精度浮点数
    func putDouble(_ key: String, _ value: Double) {
        getMMKV().set(value, forKey: key)
        getMMKV().synchronize()
    }
    
    // 存储双精度浮点数，使用指定ID的实例
    func putDouble(id: String, key: String, value: Double) {
        getMMKV(id: id).set(value, forKey: key)
        getMMKV(id: id).synchronize()
    }
    
    // 获取双精度浮点数
    func getDouble(_ key: String, _ defaultValue: Double = 0.0) -> Double {
        return getMMKV().double(forKey: key)
    }
    
    // 获取双精度浮点数，使用指定ID的实例
    func getDouble(id: String, key: String, defaultValue: Double = 0.0) -> Double {
        return getMMKV(id: id).double(forKey: key)
    }
    
    // 存储布尔值
    func putBoolean(_ key: String, _ value: Bool) {
        getMMKV().set(value, forKey: key)
        getMMKV().synchronize()
    }
    
    // 存储布尔值，使用指定ID的实例
    func putBoolean(id: String, key: String, value: Bool) {
        getMMKV(id: id).set(value, forKey: key)
        getMMKV(id: id).synchronize()
    }
    
    // 获取布尔值
    func getBoolean(_ key: String, _ defaultValue: Bool = false) -> Bool {
        return getMMKV().bool(forKey: key)
    }
    
    // 获取布尔值，使用指定ID的实例
    func getBoolean(id: String, key: String, defaultValue: Bool = false) -> Bool {
        return getMMKV(id: id).bool(forKey: key)
    }
    
    // 移除键值对
    func remove(_ key: String) {
        getMMKV().removeObject(forKey: key)
        getMMKV().synchronize()
    }
    
    // 移除键值对，使用指定ID的实例
    func remove(id: String, key: String) {
        getMMKV(id: id).removeObject(forKey: key)
        getMMKV(id: id).synchronize()
    }
    
    // 清空所有数据
    func clear() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            getMMKV().removePersistentDomain(forName: bundleIdentifier)
            getMMKV().synchronize()
        }
    }
    
    // 清空指定ID的实例的所有数据
    func clear(id: String) {
        let suiteName = "com.self.improvement.\(id)"
        getMMKV(id: id).removePersistentDomain(forName: suiteName)
        getMMKV(id: id).synchronize()
    }
}
