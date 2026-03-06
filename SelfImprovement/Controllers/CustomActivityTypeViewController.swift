//
//  CustomActivityTypeViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  自定义活动类型管理界面
//

import UIKit

protocol CustomActivityTypeDelegate: AnyObject {
    func didSelectActivityType(_ type: String)
}

class CustomActivityTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: CustomActivityTypeDelegate?
    
    private let dbHelper = DatabaseHelper.shared
    
    private var defaultTypes: [String] = AppConfig.DEFAULT_ACTIVITY_TYPES
    private var customTypes: [CustomActivityType] = []
    
    private let tableView = UITableView()
    private let addButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCustomTypes()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "选择活动类型"
        
        addButton.image = UIImage(systemName: "plus")
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        navigationItem.rightBarButtonItem = addButton
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TypeCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadCustomTypes() {
        customTypes = dbHelper.getAllCustomActivityTypes()
        tableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "添加自定义类型", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "输入类型名称"
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "添加", style: .default) { [weak self] _ in
            guard let name = alert.textFields?[0].text, !name.isEmpty else { return }
            
            let customType = CustomActivityType(name: name)
            self?.dbHelper.addCustomActivityType(customType)
            self?.loadCustomTypes()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? defaultTypes.count : customTypes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "默认类型" : "自定义类型"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = defaultTypes[indexPath.row]
        } else {
            cell.textLabel?.text = customTypes[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedType: String
        if indexPath.section == 0 {
            selectedType = defaultTypes[indexPath.row]
        } else {
            selectedType = customTypes[indexPath.row].name
        }
        
        delegate?.didSelectActivityType(selectedType)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let customType = customTypes[indexPath.row]
            dbHelper.deleteCustomActivityType(id: customType.id)
            customTypes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
