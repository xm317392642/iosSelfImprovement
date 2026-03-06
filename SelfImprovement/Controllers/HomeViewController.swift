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
    
    // GIF 相关
    private var currentDecayGifName: String = ""
    private var currentPositiveGifName: String = ""
    private var zhanglangGifViews = [UIImageView]()
    
    // UI 组件
    private let circleProgressBar = CircleProgressBar()
    private let healthLevelLabel = UILabel()
    private let entertainmentTimeLabel = UILabel()
    private let activityCountLabel = UILabel()
    private let quoteLabel = UILabel()
    private let refreshButton = UIButton(type: .system)
    private let cameraButton = UIButton(type: .system)
    private let decayImageView = UIImageView()
    private let positiveImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEventObservers()
        updateData()
        initGifDisplay()
        initZhanglangGifs()
        showMotivationalQuoteCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    deinit {
        EventCenter.shared.removeObserver(self)
    }
    
    private func setupEventObservers() {
        EventCenter.shared.observe(AppConfig.EVENT_REFRESH_HOME_DATA, observer: self) { [weak self] (_: Bool?) in
            self?.updateData()
        }
        
        EventCenter.shared.observe(AppConfig.EVENT_SCORE_CHANGED, observer: self) { [weak self] (score: Int?) in
            if let score = score {
                self?.healthScore = Double(score)
                self?.updateUI()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "自我提升"
        
        // 健康值圆形进度条
        let healthScoreView = UIView()
        healthScoreView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        healthScoreView.layer.cornerRadius = 12
        view.addSubview(healthScoreView)
        
        circleProgressBar.lineWidth = 12
        healthScoreView.addSubview(circleProgressBar)
        
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
        
        // 颓废状态 GIF
        decayImageView.contentMode = .scaleAspectFit
        entertainmentView.addSubview(decayImageView)
        
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
        
        // 正向状态 GIF
        positiveImageView.contentMode = .scaleAspectFit
        activityView.addSubview(positiveImageView)
        
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
        circleProgressBar.translatesAutoresizingMaskIntoConstraints = false
        healthLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        entertainmentView.translatesAutoresizingMaskIntoConstraints = false
        entertainmentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        entertainmentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        decayImageView.translatesAutoresizingMaskIntoConstraints = false
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        activityCountLabel.translatesAutoresizingMaskIntoConstraints = false
        positiveImageView.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            healthScoreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            healthScoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            healthScoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            healthScoreView.heightAnchor.constraint(equalToConstant: 200),
            
            circleProgressBar.centerXAnchor.constraint(equalTo: healthScoreView.centerXAnchor),
            circleProgressBar.centerYAnchor.constraint(equalTo: healthScoreView.centerYAnchor, constant: -10),
            circleProgressBar.widthAnchor.constraint(equalToConstant: 140),
            circleProgressBar.heightAnchor.constraint(equalToConstant: 140),
            
            healthLevelLabel.topAnchor.constraint(equalTo: circleProgressBar.bottomAnchor, constant: 10),
            healthLevelLabel.centerXAnchor.constraint(equalTo: healthScoreView.centerXAnchor),
            
            statsStackView.topAnchor.constraint(equalTo: healthScoreView.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 120),
            
            entertainmentTitleLabel.topAnchor.constraint(equalTo: entertainmentView.topAnchor, constant: 10),
            entertainmentTitleLabel.centerXAnchor.constraint(equalTo: entertainmentView.centerXAnchor),
            
            entertainmentTimeLabel.topAnchor.constraint(equalTo: entertainmentTitleLabel.bottomAnchor, constant: 5),
            entertainmentTimeLabel.centerXAnchor.constraint(equalTo: entertainmentView.centerXAnchor),
            
            decayImageView.topAnchor.constraint(equalTo: entertainmentTimeLabel.bottomAnchor, constant: 5),
            decayImageView.centerXAnchor.constraint(equalTo: entertainmentView.centerXAnchor),
            decayImageView.widthAnchor.constraint(equalToConstant: 60),
            decayImageView.heightAnchor.constraint(equalToConstant: 60),
            
            activityTitleLabel.topAnchor.constraint(equalTo: activityView.topAnchor, constant: 10),
            activityTitleLabel.centerXAnchor.constraint(equalTo: activityView.centerXAnchor),
            
            activityCountLabel.topAnchor.constraint(equalTo: activityTitleLabel.bottomAnchor, constant: 5),
            activityCountLabel.centerXAnchor.constraint(equalTo: activityView.centerXAnchor),
            
            positiveImageView.topAnchor.constraint(equalTo: activityCountLabel.bottomAnchor, constant: 5),
            positiveImageView.centerXAnchor.constraint(equalTo: activityView.centerXAnchor),
            positiveImageView.widthAnchor.constraint(equalToConstant: 60),
            positiveImageView.heightAnchor.constraint(equalToConstant: 60),
            
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
        
        circleProgressBar.setProgress(CGFloat(healthScore / 100.0), animated: true)
        healthLevelLabel.text = healthLevel
        healthLevelLabel.textColor = healthColor
        
        // 从 MMKV 获取娱乐时间
        entertainmentTime = Int64(MMKVUtil.shared.getInt("entertainment_time", 0)) * 60 * 1000 // 转换为毫秒
        entertainmentTimeLabel.text = DateUtils.shared.formatTimeInterval(entertainmentTime)
        
        activityCount = activityRecordRepository.getTodayActivityCount()
        activityCountLabel.text = "\(activityCount) 个"
        
        quoteLabel.text = motivationalQuotesUtil.getRandomQuote()
        
        // 更新 GIF 显示
        updateGifResource()
    }
    
    private func updateUI() {
        let healthLevel = HealthValueCalculator.shared.getHealthLevel(score: healthScore)
        let healthColor = HealthValueCalculator.shared.getHealthColor(score: healthScore)
        
        circleProgressBar.setProgress(CGFloat(healthScore / 100.0), animated: true)
        healthLevelLabel.text = healthLevel
        healthLevelLabel.textColor = healthColor
        
        // 更新 GIF 显示
        updateGifResource()
    }
    
    @objc private func refreshButtonTapped() {
        refreshButton.animatePress()
        updateData()
    }
    
    @objc private func cameraButtonTapped() {
        cameraButton.animatePress()
        let cameraVC = CameraViewController()
        navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    // MARK: - GIF 相关方法
    
    private func initGifDisplay() {
        // 加载颓废状态 GIF
        decayImageView.loadGIF(named: "duoluo")
        currentDecayGifName = "duoluo"
        
        // 加载正向状态 GIF
        positiveImageView.loadGIF(named: "zhengxiang")
        currentPositiveGifName = "zhengxiang"
        
        // 根据当前健康值更新 GIF 资源
        updateGifResource()
    }
    
    private func initZhanglangGifs() {
        // 创建 5 个蟑螂 GIF 视图
        for i in 0..<5 {
            let zhanglangView = UIImageView()
            zhanglangView.contentMode = .scaleAspectFit
            zhanglangView.isHidden = true
            view.addSubview(zhanglangView)
            zhanglangView.translatesAutoresizingMaskIntoConstraints = false
            
            // 随机位置
            let randomX = CGFloat.random(in: 20...(view.bounds.width - 80))
            let randomY = CGFloat.random(in: 100...(view.bounds.height - 100))
            
            NSLayoutConstraint.activate([
                zhanglangView.widthAnchor.constraint(equalToConstant: 60),
                zhanglangView.heightAnchor.constraint(equalToConstant: 60),
                zhanglangView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: randomX),
                zhanglangView.topAnchor.constraint(equalTo: view.topAnchor, constant: randomY)
            ])
            
            zhanglangGifViews.append(zhanglangView)
        }
        
        // 根据当前健康值更新蟑螂 GIF
        updateZhanglangGif()
    }
    
    private func updateGifResource() {
        // 更新颓废状态 GIF
        updateDecayGifResource()
        
        // 更新正向状态 GIF
        updatePositiveGifResource()
        
        // 更新蟑螂 GIF
        updateZhanglangGif()
    }
    
    private func updateDecayGifResource() {
        if healthScore <= 60 {
            // 健康值小于 60 分，播放 die.gif
            if currentDecayGifName != "die" {
                decayImageView.loadGIF(named: "die")
                currentDecayGifName = "die"
            }
        } else {
            // 健康值大于等于 60 分，播放默认的 duoluo.gif
            if currentDecayGifName != "duoluo" {
                decayImageView.loadGIF(named: "duoluo")
                currentDecayGifName = "duoluo"
            }
        }
    }
    
    private func updatePositiveGifResource() {
        if healthScore == 100 {
            // 健康值等于 100 分，播放 success.gif
            if currentPositiveGifName != "success" {
                positiveImageView.loadGIF(named: "success")
                currentPositiveGifName = "success"
            }
        } else {
            // 健康值小于 100 分，播放默认的 zhengxiang.gif
            if currentPositiveGifName != "zhengxiang" {
                positiveImageView.loadGIF(named: "zhengxiang")
                currentPositiveGifName = "zhengxiang"
            }
        }
    }
    
    private func updateZhanglangGif() {
        // 隐藏所有蟑螂 GIF
        zhanglangGifViews.forEach { $0.isHidden = true }
        
        // 根据健康值确定要显示的 GIF 数量
        let displayCount: Int
        if healthScore >= 100 {
            displayCount = 0
        } else if healthScore >= 95 {
            displayCount = 1
        } else if healthScore >= 90 {
            displayCount = 2
        } else if healthScore >= 85 {
            displayCount = 3
        } else if healthScore >= 80 {
            displayCount = 4
        } else {
            displayCount = 5
        }
        
        // 显示对应数量的蟑螂 GIF
        for i in 0..<min(displayCount, zhanglangGifViews.count) {
            let gifView = zhanglangGifViews[i]
            gifView.loadGIF(named: "zhanglang")
            gifView.isHidden = false
            // 置于顶层
            view.bringSubviewToFront(gifView)
        }
    }
    
    // MARK: - 其他方法
    
    private func showMotivationalQuoteCard() {
        // 获取当天日期作为key后缀
        let todayDate = DateUtils.shared.getTodayString()
        let quoteKey = "quote_shown_\(todayDate)"
        
        // 检查当天是否已经显示过励志话语卡片
        let hasShownToday = MMKVUtil.shared.getBoolean(quoteKey, false)
        
        if !hasShownToday {
            // 设置随机励志话语
            let quoteText = motivationalQuotesUtil.getRandomQuote()
            
            // 创建并显示对话框
            let alertController = UIAlertController(title: "励志语录", message: quoteText, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default)
            alertController.addAction(confirmAction)
            
            // 显示对话框
            present(alertController, animated: true)
            
            // 标记当天已经显示过励志话语卡片
            MMKVUtil.shared.putBoolean(quoteKey, true)
        }
    }
}
