//
//  AppSelectionViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

protocol AppSelectionViewControllerDelegate: AnyObject {
    func appSelectionDidFinish(selectedApps: Set<String>)
}

class AppSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    weak var delegate: AppSelectionViewControllerDelegate?
    var selectedApps: Set<String> = []
    
    private let appUtil = AppUtil.shared
    private let appUsageRepository = AppUsageRepository.shared
    
    private var allApps: [AppInfo] = []
    private var filteredApps: [AppInfo] = []
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let confirmButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadApps()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "选择应用"
        
        confirmButton.title = "确定"
        confirmButton.target = self
        confirmButton.action = #selector(confirmButtonTapped)
        navigationItem.rightBarButtonItem = confirmButton
        
        searchBar.delegate = self
        searchBar.placeholder = "搜索应用"
        view.addSubview(searchBar)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppCell")
        view.addSubview(tableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadApps() {
        allApps = appUtil.loadAllApps(monitoredApps: selectedApps)
        filteredApps = allApps
        tableView.reloadData()
    }
    
    @objc private func confirmButtonTapped() {
        delegate?.appSelectionDidFinish(selectedApps: selectedApps)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredApps = allApps
        } else {
            filteredApps = allApps.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredApps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
        let app = filteredApps[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = app.name
        content.secondaryText = DateUtils.shared.formatTimeInterval(app.dailyUsageTime)
        cell.contentConfiguration = content
        
        cell.accessoryType = selectedApps.contains(app.appPackageName) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = filteredApps[indexPath.row]
        if selectedApps.contains(app.appPackageName) {
            selectedApps.remove(app.appPackageName)
        } else {
            selectedApps.insert(app.appPackageName)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
