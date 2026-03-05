//
//  ActivityRecordViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class ActivityRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let activityRecordRepository = ActivityRecordRepository.shared
    
    private var activityTypes: [String] = ["学习", "运动", "阅读", "工作", "其他"]
    private var selectedType: String = "学习"
    private var activities: [ActivityRecord] = []
    
    private let tableView = UITableView()
    private let addButton = UIBarButtonItem()
    private let typeSegmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadActivities()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "正向活动"
        
        addButton.image = UIImage(systemName: "plus")
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        navigationItem.rightBarButtonItem = addButton
        
        typeSegmentedControl.insertSegment(withTitle: "学习", at: 0, animated: false)
        typeSegmentedControl.insertSegment(withTitle: "运动", at: 1, animated: false)
        typeSegmentedControl.insertSegment(withTitle: "阅读", at: 2, animated: false)
        typeSegmentedControl.insertSegment(withTitle: "工作", at: 3, animated: false)
        typeSegmentedControl.insertSegment(withTitle: "其他", at: 4, animated: false)
        typeSegmentedControl.selectedSegmentIndex = 0
        typeSegmentedControl.addTarget(self, action: #selector(typeChanged), for: .valueChanged)
        view.addSubview(typeSegmentedControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        view.addSubview(tableView)
        
        typeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            typeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadActivities() {
        let today = DateUtils.shared.getTodayString()
        activities = activityRecordRepository.getActivityRecordsByType(selectedType, date: today)
        tableView.reloadData()
    }
    
    @objc private func typeChanged() {
        selectedType = activityTypes[typeSegmentedControl.selectedSegmentIndex]
        loadActivities()
    }
    
    @objc private func addButtonTapped() {
        let addActivityVC = AddActivityViewController()
        addActivityVC.activityType = selectedType
        addActivityVC.delegate = self
        navigationController?.pushViewController(addActivityVC, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        let activity = activities[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = activity.title
        content.secondaryText = activity.content
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activity = activities[indexPath.row]
        let detailVC = ActivityDetailViewController(activity: activity)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 这里可以添加删除逻辑
            activities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - AddActivityViewControllerDelegate

extension ActivityRecordViewController: AddActivityViewControllerDelegate {
    func activityAdded() {
        loadActivities()
    }
}
