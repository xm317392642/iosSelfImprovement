//
//  AddActivityViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

protocol AddActivityViewControllerDelegate: AnyObject {
    func activityAdded()
}

class AddActivityViewController: UIViewController {
    
    weak var delegate: AddActivityViewControllerDelegate?
    var activityType: String = "学习"
    
    private let activityRecordRepository = ActivityRecordRepository.shared
    
    private let titleTextField = UITextField()
    private let contentTextView = UITextView()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "添加活动"
        
        let titleLabel = UILabel()
        titleLabel.text = "标题"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(titleLabel)
        
        titleTextField.placeholder = "请输入活动标题"
        titleTextField.borderStyle = .roundedRect
        view.addSubview(titleTextField)
        
        let contentLabel = UILabel()
        contentLabel.text = "内容"
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(contentLabel)
        
        contentTextView.placeholder = "请输入活动内容"
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.cornerRadius = 8
        view.addSubview(contentTextView)
        
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            contentLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            contentTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentTextView.heightAnchor.constraint(equalToConstant: 150),
            
            saveButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "请输入标题")
            return
        }
        
        let content = contentTextView.text ?? ""
        let today = DateUtils.shared.getTodayString()
        
        let activity = ActivityRecord(title: title, content: content, type: activityType, date: today)
        activityRecordRepository.addActivityRecord(activity)
        
        delegate?.activityAdded()
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
