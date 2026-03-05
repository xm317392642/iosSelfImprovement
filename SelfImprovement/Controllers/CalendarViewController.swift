//
//  CalendarViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class CalendarViewController: UIViewController {
    
    private let healthScoreRepository = HealthScoreRepository.shared
    
    private let calendarView = UICalendarView()
    private let healthScoreLabel = UILabel()
    
    private var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateHealthScore()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "健康日历"
        
        calendarView.delegate = self
        calendarView.setDateSelectionBehavior(UICalendarSelectionSingleDate(delegate: self))
        view.addSubview(calendarView)
        
        healthScoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        healthScoreLabel.textAlignment = .center
        healthScoreLabel.textColor = .black
        view.addSubview(healthScoreLabel)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        healthScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calendarView.heightAnchor.constraint(equalToConstant: 300),
            
            healthScoreLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30),
            healthScoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            healthScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func updateHealthScore() {
        let dateString = DateUtils.shared.getDateString(selectedDate)
        if let status = healthScoreRepository.getHealthStatus(for: dateString) {
            let healthLevel = HealthValueCalculator.shared.getHealthLevel(score: status.healthScore)
            healthScoreLabel.text = "\(dateString)\n健康值：\(String(format: "%.1f", status.healthScore))\n状态：\(healthLevel)"
        } else {
            healthScoreLabel.text = "\(dateString)\n暂无数据"
        }
    }
}

// MARK: - UICalendarViewDelegate

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let dateString = DateUtils.shared.getDateString(Calendar.current.date(from: dateComponents)!)
        if let status = healthScoreRepository.getHealthStatus(for: dateString) {
            let color = HealthValueCalculator.shared.getHealthColor(score: status.healthScore)
            return UICalendarView.Decoration.default(color: color, size: .medium)
        }
        return nil
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let dateComponents = dateComponents {
            selectedDate = Calendar.current.date(from: dateComponents)!
            updateHealthScore()
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}
