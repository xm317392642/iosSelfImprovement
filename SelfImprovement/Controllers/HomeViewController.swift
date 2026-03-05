//
//  HomeViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let healthScoreRepository = HealthScoreRepository.shared
    private let appUsageRepository = AppUsageRepository.shared
    private let activityRecordRepository = ActivityRecordRepository.shared
    private let motivationalQuotesUtil = MotivationalQuotesUtil.shared
    
    private var healthScore: Double = 0.0
    private var entertainmentTime: Int64 = 0
    private var activityCount: Int = 0
    
    // UI 组件
    private let healthScoreLabel = UILabel()
    private let healthLevelLabel = UILabel()
    private let entertainmentTimeLabel = UILabel()
    private let activityCountLabel = UILabel()
    private let quoteLabel = UILabel()
    private let refreshButton = UIButton(type: .system)
    private let cameraButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "自我提升"
        
        // 健康值显示
        let healthScoreView = UIView()
        healthScoreView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        healthScoreView.layer.cornerRadius = 12
        view.addSubview(healthScoreView)
        
        healthScoreLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        healthScoreLabel.textAlignment = .center
        healthScoreView.addSubview(healthScoreLabel)
        
        healthLevelLabel.font = UIFont.systemFont(ofSize: 18)
        healthLevelLabel.textAlignment = .center
        healthScoreView.addSubview(healthLevelLabel)
        
        // 统计信息
        let statsStackView = UIStackView()
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 20
        view.addSubview(statsStackView)
        
        let entertainmentView = UIView()
        entertainmentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        entertainmentView.layer.cornerRadius = 8
        statsStackView.addArrangedSubview(entertainmentView)
        
        let entertainmentTitleLabel = UILabel()
        entertainmentTitleLabel.text = "娱乐时间"
        entertainmentTitleLabel.font = UIFont.systemFont(ofSize: 14)
        entertainmentTitleLabel.textAlignment = .center
        entertainmentView.addSubview(entertainmentTitleLabel)
        
        entertainmentTimeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        entertainmentTimeLabel.textAlignment = .center
        entertainmentView.addSubview(entertainmentTimeLabel)
        
        let activityView = UIView()
        activityView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        activityView.layer.cornerRadius = 8
        statsStackView.addArrangedSubview(activityView)
        
        let activityTitleLabel = UILabel()
        activityTitleLabel.text = "正向活动"
        activityTitleLabel.font = UIFont.systemFont(ofSize: 14)
        activityTitleLabel.textAlignment = .center
        activityView.addSubview(activityTitleLabel)
        
        activityCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        activityCountLabel.textAlignment = .center
        activityView.addSubview(activityCountLabel)
        
        // 励志语录
        quoteLabel.font = UIFont.systemFont(ofSize: 16)
        quoteLabel.textAlignment = .center
        quoteLabel.numberOfLines = 2
        quoteLabel.textColor = .gray
        view.addSubview(quoteLabel)
        
        // 操作按钮
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        view.addSubview(buttonStackView)
        
        refreshButton.setTitle("刷新", for: .normal)
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.backgroundColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        refreshButton.layer.cornerRadius = 8
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(refreshButton)
        
        cameraButton.setTitle("拍照", for: .normal)
        cameraButton.setTitleColor(.white, for: .normal)
        cameraButton.backgroundColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        cameraButton.layer.cornerRadius = 8
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(cameraButton)
        
        // 布局
        healthScoreView.translatesAutoresizingMaskIntoConstraints = false
        healthScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        healthLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        entertainmentView.translatesAutoresizingMaskIntoConstraints = false
        entertainmentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        entertainmentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        activityCountLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            healthScoreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            healthScoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            healthScoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            healthScoreView.heightAnchor.constraint(equalToConstant: 150),
            
            healthScoreLabel.centerXAnchor.constraint(equalTo: healthScoreView.centerXAnchor),
            healthScoreLabel.centerYAnchor.constraint(equalTo: healthScoreView.centerYAnchor, constant: -10),
            
            healthLevelLabel.topAnchor.constraint(equalTo: healthScoreLabel.bottomAnchor, constant: 10),
            healthLevelLabel.centerXAnchor.constraint(equalTo: healthScoreView.centerXAnchor),
            
            statsStackView.topAnchor.constraint(equalTo: healthScoreView.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            entertainmentTitleLabel.topAnchor.constraint(equalTo: entertainmentView.topAnchor, constant: 10),
            entertainmentTitleLabel.centerXAnchor.constraint(equalTo: entertainmentView.centerXAnchor),
            
            entertainmentTimeLabel.topAnchor.constraint(equalTo: entertainmentTitleLabel.bottomAnchor, constant: 10),
            entertainmentTimeLabel.centerXAnchor.constraint(equalTo: entertainmentView.centerXAnchor),
            
            activityTitleLabel.topAnchor.constraint(equalTo: activityView.topAnchor, constant: 10),
            activityTitleLabel.centerXAnchor.constraint(equalTo: activityView.centerXAnchor),
            
            activityCountLabel.topAnchor.constraint(equalTo: activityTitleLabel.bottomAnchor, constant: 10),
            activityCountLabel.centerXAnchor.constraint(equalTo: activityView.centerXAnchor),
            
            quoteLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 30),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            buttonStackView.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 40),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateData() {
        healthScore = healthScoreRepository.getTodayHealthScore()
        let healthLevel = HealthValueCalculator.shared.getHealthLevel(score: healthScore)
        let healthColor = HealthValueCalculator.shared.getHealthColor(score: healthScore)
        
        healthScoreLabel.text = String(format: "%.1f", healthScore)
        healthScoreLabel.textColor = healthColor
        healthLevelLabel.text = healthLevel
        healthLevelLabel.textColor = healthColor
        
        entertainmentTime = appUsageRepository.getTodayMonitoredAppsTotalUsageTime()
        entertainmentTimeLabel.text = DateUtils.shared.formatTimeInterval(entertainmentTime)
        
        activityCount = activityRecordRepository.getTodayActivityCount()
        activityCountLabel.text = "\(activityCount) 个"
        
        quoteLabel.text = motivationalQuotesUtil.getRandomQuote()
    }
    
    @objc private func refreshButtonTapped() {
        updateData()
    }
    
    @objc private func cameraButtonTapped() {
        // 打开相机
        let cameraVC = CameraViewController()
        navigationController?.pushViewController(cameraVC, animated: true)
    }
}
