//
//  EventCenter.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  事件中心，用于组件间通信，替代 Android 的 LiveEventBus
//

import Foundation

class EventCenter {
    static let shared = EventCenter()
    
    private var observers = [String: [WeakObserver]]()
    private let queue = DispatchQueue(label: "com.selfimprovement.eventcenter", attributes: .concurrent)
    
    private init() {}
    
    struct WeakObserver {
        weak var observer: AnyObject?
        let handler: (Any?) -> Void
    }
    
    func observe<T>(_ eventName: String, observer: AnyObject, handler: @escaping (T?) -> Void) {
        queue.async(flags: .barrier) {
            let weakObserver = WeakObserver(observer: observer) { value in
                if let typedValue = value as? T {
                    handler(typedValue)
                } else if value == nil {
                    handler(nil)
                }
            }
            
            if self.observers[eventName] == nil {
                self.observers[eventName] = []
            }
            self.observers[eventName]?.append(weakObserver)
        }
    }
    
    func post(_ eventName: String, value: Any? = nil) {
        queue.async {
            guard var observerList = self.observers[eventName] else { return }
            
            observerList = observerList.filter { $0.observer != nil }
            self.observers[eventName] = observerList
            
            observerList.forEach { $0.handler(value) }
        }
    }
    
    func removeObserver(_ observer: AnyObject, eventName: String? = nil) {
        queue.async(flags: .barrier) {
            if let eventName = eventName {
                self.observers[eventName]?.removeAll { $0.observer === observer }
            } else {
                self.observers.keys.forEach { key in
                    self.observers[key]?.removeAll { $0.observer === observer }
                }
            }
        }
    }
}

extension Notification.Name {
    static let healthScoreChanged = Notification.Name("healthScoreChanged")
    static let monitoredAppsUpdated = Notification.Name("monitoredAppsUpdated")
    static let activityRecordAdded = Notification.Name("activityRecordAdded")
    static let avatarUpdated = Notification.Name("avatarUpdated")
    static let refreshHomeData = Notification.Name("refreshHomeData")
    static let refreshPublishCounts = Notification.Name("refreshPublishCounts")
}
