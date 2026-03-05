//
//  MainTabBarController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let homeViewController = HomeViewController()
        let monitoredAppViewController = MonitoredAppListViewController()
        let activityViewController = ActivityRecordViewController()
        let profileViewController = ProfileViewController()
        
        homeViewController.tabBarItem = UITabBarItem(title: "首页", image: UIImage(systemName: "house"), tag: 0)
        monitoredAppViewController.tabBarItem = UITabBarItem(title: "监控", image: UIImage(systemName: "eye"), tag: 1)
        activityViewController.tabBarItem = UITabBarItem(title: "活动", image: UIImage(systemName: "star"), tag: 2)
        profileViewController.tabBarItem = UITabBarItem(title: "我的", image: UIImage(systemName: "person"), tag: 3)
        
        let homeNav = UINavigationController(rootViewController: homeViewController)
        let monitoredAppNav = UINavigationController(rootViewController: monitoredAppViewController)
        let activityNav = UINavigationController(rootViewController: activityViewController)
        let profileNav = UINavigationController(rootViewController: profileViewController)
        
        viewControllers = [homeNav, monitoredAppNav, activityNav, profileNav]
        
        // 设置 TabBar 样式
        tabBar.tintColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        tabBar.unselectedItemTintColor = .gray
    }
}
