//
//  AboutViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class AboutViewController: UIViewController {
    
    private let appIconImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let versionLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "关于我们"
        
        appIconImageView.image = UIImage(systemName: "star.circle.fill")
        appIconImageView.tintColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        appIconImageView.contentMode = .scaleAspectFit
        view.addSubview(appIconImageView)
        
        appNameLabel.text = "自我提升"
        appNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        appNameLabel.textAlignment = .center
        view.addSubview(appNameLabel)
        
        versionLabel.text = "版本 1.0.0"
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textColor = .gray
        versionLabel.textAlignment = .center
        view.addSubview(versionLabel)
        
        descriptionLabel.text = "自我提升应用是一款专注于帮助用户管理时间、记录正向活动、提升个人健康值的移动应用。通过监控娱乐应用使用时间并鼓励用户参与正向活动，帮助用户建立健康的生活习惯。"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            appIconImageView.widthAnchor.constraint(equalToConstant: 100),
            appIconImageView.heightAnchor.constraint(equalToConstant: 100),
            
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 20),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            versionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 10),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
