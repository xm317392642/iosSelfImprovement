//
//  ProfileEditViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    private let nameTextField = UITextField()
    private let genderSegmentedControl = UISegmentedControl()
    private let signatureTextView = UITextView()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "编辑个人信息"
        
        let nameLabel = UILabel()
        nameLabel.text = "昵称"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(nameLabel)
        
        nameTextField.placeholder = "请输入昵称"
        nameTextField.borderStyle = .roundedRect
        view.addSubview(nameTextField)
        
        let genderLabel = UILabel()
        genderLabel.text = "性别"
        genderLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(genderLabel)
        
        genderSegmentedControl.insertSegment(withTitle: "男", at: 0, animated: false)
        genderSegmentedControl.insertSegment(withTitle: "女", at: 1, animated: false)
        genderSegmentedControl.insertSegment(withTitle: "其他", at: 2, animated: false)
        genderSegmentedControl.selectedSegmentIndex = 2
        view.addSubview(genderSegmentedControl)
        
        let signatureLabel = UILabel()
        signatureLabel.text = "个性签名"
        signatureLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(signatureLabel)
        
        signatureTextView.placeholder = "请输入个性签名"
        signatureTextView.layer.borderWidth = 1
        signatureTextView.layer.borderColor = UIColor.lightGray.cgColor
        signatureTextView.layer.cornerRadius = 8
        view.addSubview(signatureTextView)
        
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        signatureLabel.translatesAutoresizingMaskIntoConstraints = false
        signatureTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            genderLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            genderSegmentedControl.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            genderSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            signatureLabel.topAnchor.constraint(equalTo: genderSegmentedControl.bottomAnchor, constant: 20),
            signatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            signatureTextView.topAnchor.constraint(equalTo: signatureLabel.bottomAnchor, constant: 10),
            signatureTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signatureTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signatureTextView.heightAnchor.constraint(equalToConstant: 100),
            
            saveButton.topAnchor.constraint(equalTo: signatureTextView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loadUserData() {
        // 从 MMKV 获取用户数据
        if let savedNickname = MMKVUtil.shared.getStringOrNull("user_nickname") {
            nameTextField.text = savedNickname
        }
        
        if let savedGender = MMKVUtil.shared.getStringOrNull("user_gender") {
            switch savedGender {
            case "男":
                genderSegmentedControl.selectedSegmentIndex = 0
            case "女":
                genderSegmentedControl.selectedSegmentIndex = 1
            default:
                genderSegmentedControl.selectedSegmentIndex = 2
            }
        }
        
        if let savedSignature = MMKVUtil.shared.getStringOrNull("user_signature") {
            signatureTextView.text = savedSignature
        }
    }
    
    @objc private func saveButtonTapped() {
        // 保存个人信息到 MMKV
        if let nickname = nameTextField.text, !nickname.isEmpty {
            MMKVUtil.shared.putString("user_nickname", nickname)
        }
        
        let genderIndex = genderSegmentedControl.selectedSegmentIndex
        let genderValue: String
        switch genderIndex {
        case 0:
            genderValue = "男"
        case 1:
            genderValue = "女"
        default:
            genderValue = "其他"
        }
        MMKVUtil.shared.putString("user_gender", genderValue)
        
        let signature = signatureTextView.text ?? ""
        MMKVUtil.shared.putString("user_signature", signature)
        
        // 保存成功，返回上一页
        navigationController?.popViewController(animated: true)
    }
}

