//
//  ProfileViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let healthScoreRepository = HealthScoreRepository.shared
    
    private let tableView = UITableView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let statsView = UIView()
    private let hundredScoreDaysLabel = UILabel()
    private let totalActivitiesLabel = UILabel()
    
    private let menuItems = ["个人信息", "日历", "关于我们", "设置"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStats()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "个人中心"
        
        // 头像和信息
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        view.addSubview(headerView)
        
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = .white
        avatarImageView.contentMode = .scaleAspectFit
        headerView.addSubview(avatarImageView)
        
        nameLabel.text = "用户"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        headerView.addSubview(nameLabel)
        
        // 统计信息
        statsView.backgroundColor = .white
        statsView.layer.cornerRadius = 12
        statsView.layer.shadowColor = UIColor.black.cgColor
        statsView.layer.shadowOffset = CGSize(width: 0, height: 2)
        statsView.layer.shadowOpacity = 0.1
        statsView.layer.shadowRadius = 4
        view.addSubview(statsView)
        
        let hundredScoreDaysTitleLabel = UILabel()
        hundredScoreDaysTitleLabel.text = "100分天数"
        hundredScoreDaysTitleLabel.font = UIFont.systemFont(ofSize: 14)
        hundredScoreDaysTitleLabel.textColor = .gray
        statsView.addSubview(hundredScoreDaysTitleLabel)
        
        hundredScoreDaysLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        hundredScoreDaysLabel.textColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        statsView.addSubview(hundredScoreDaysLabel)
        
        let totalActivitiesTitleLabel = UILabel()
        totalActivitiesTitleLabel.text = "总活动数"
        totalActivitiesTitleLabel.font = UIFont.systemFont(ofSize: 14)
        totalActivitiesTitleLabel.textColor = .gray
        statsView.addSubview(totalActivitiesTitleLabel)
        
        totalActivitiesLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        totalActivitiesLabel.textColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        statsView.addSubview(totalActivitiesLabel)
        
        // 菜单列表
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        view.addSubview(tableView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statsView.translatesAutoresizingMaskIntoConstraints = false
        hundredScoreDaysTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        hundredScoreDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        totalActivitiesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalActivitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 200),
            
            avatarImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            statsView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            statsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsView.heightAnchor.constraint(equalToConstant: 80),
            
            hundredScoreDaysTitleLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 10),
            hundredScoreDaysTitleLabel.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20),
            
            hundredScoreDaysLabel.topAnchor.constraint(equalTo: hundredScoreDaysTitleLabel.bottomAnchor, constant: 5),
            hundredScoreDaysLabel.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 20),
            
            totalActivitiesTitleLabel.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 10),
            totalActivitiesTitleLabel.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20),
            
            totalActivitiesLabel.topAnchor.constraint(equalTo: totalActivitiesTitleLabel.bottomAnchor, constant: 5),
            totalActivitiesLabel.trailingAnchor.constraint(equalTo: statsView.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateStats() {
        let hundredScoreDays = healthScoreRepository.getHundredScoreDaysCount()
        hundredScoreDaysLabel.text = "\(hundredScoreDays)"
        
        // 这里可以添加总活动数的计算
        totalActivitiesLabel.text = "0"
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = menuItems[indexPath.row]
        content.secondaryText = ""
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            // 个人信息
            let profileEditVC = ProfileEditViewController()
            navigationController?.pushViewController(profileEditVC, animated: true)
        case 1:
            // 日历
            let calendarVC = CalendarViewController()
            navigationController?.pushViewController(calendarVC, animated: true)
        case 2:
            // 关于我们
            let aboutVC = AboutViewController()
            navigationController?.pushViewController(aboutVC, animated: true)
        case 3:
            // 设置
            let settingsVC = SettingsViewController()
            navigationController?.pushViewController(settingsVC, animated: true)
        default:
            break
        }
    }
}
