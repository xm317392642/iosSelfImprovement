//
//  MonitoredAppListViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class MonitoredAppListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let appUtil = AppUtil.shared
    private let appUsageRepository = AppUsageRepository.shared
    
    private var allApps: [AppInfo] = []
    private var monitoredApps: Set<String> = []
    
    private let tableView = UITableView()
    private let addButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadApps()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "监控应用"
        
        addButton.image = UIImage(systemName: "plus")
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        navigationItem.rightBarButtonItem = addButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadApps() {
        allApps = appUtil.loadAllApps(monitoredApps: monitoredApps)
        tableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        let appSelectionVC = AppSelectionViewController()
        appSelectionVC.delegate = self
        appSelectionVC.selectedApps = monitoredApps
        navigationController?.pushViewController(appSelectionVC, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allApps.filter { $0.isMonitored }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
        let app = allApps.filter { $0.isMonitored }[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = app.name
        content.secondaryText = DateUtils.shared.formatTimeInterval(app.dailyUsageTime)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let app = allApps.filter { $0.isMonitored }[indexPath.row]
            appUsageRepository.removeMonitoredApp(app)
            monitoredApps.remove(app.appPackageName)
            loadApps()
        }
    }
}

// MARK: - AppSelectionViewControllerDelegate

extension MonitoredAppListViewController: AppSelectionViewControllerDelegate {
    func appSelectionDidFinish(selectedApps: Set<String>) {
        monitoredApps = selectedApps
        loadApps()
    }
}
