//
//  AddActivityViewController.swift
//  SelfImprovement
//
//  Created on 2026/3/4.
//

import UIKit
import PhotosUI

protocol AddActivityViewControllerDelegate: AnyObject {
    func activityAdded()
}

class AddActivityViewController: UIViewController {
    
    weak var delegate: AddActivityViewControllerDelegate?
    var activityType: String = "学习"
    
    private let activityRecordRepository = ActivityRecordRepository.shared
    private let mediaPicker = MediaPickerManager()
    
    private let titleTextField = UITextField()
    private let contentTextView = UITextView()
    private let saveButton = UIButton(type: .system)
    private let addMediaButton = UIButton(type: .system)
    private let mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var selectedImages: [UIImage] = []
    private var selectedVideoURL: URL?
    private var mediaPaths: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMediaPicker()
    }
    
    private func setupMediaPicker() {
        mediaPicker.delegate = self
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
        
        addMediaButton.setTitle("添加图片/视频", for: .normal)
        addMediaButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        addMediaButton.setTitleColor(.white, for: .normal)
        addMediaButton.backgroundColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        addMediaButton.layer.cornerRadius = 8
        addMediaButton.addTarget(self, action: #selector(addMediaButtonTapped), for: .touchUpInside)
        view.addSubview(addMediaButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        mediaCollectionView.collectionViewLayout = layout
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.register(MediaCell.self, forCellWithReuseIdentifier: "MediaCell")
        mediaCollectionView.isHidden = true
        view.addSubview(mediaCollectionView)
        
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
        addMediaButton.translatesAutoresizingMaskIntoConstraints = false
        mediaCollectionView.translatesAutoresizingMaskIntoConstraints = false
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
            contentTextView.heightAnchor.constraint(equalToConstant: 120),
            
            addMediaButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            addMediaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addMediaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addMediaButton.heightAnchor.constraint(equalToConstant: 44),
            
            mediaCollectionView.topAnchor.constraint(equalTo: addMediaButton.bottomAnchor, constant: 10),
            mediaCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mediaCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mediaCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            saveButton.topAnchor.constraint(equalTo: mediaCollectionView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addMediaButtonTapped() {
        mediaPicker.showMediaOptions(from: self, allowVideo: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "请输入标题")
            return
        }
        
        let content = contentTextView.text ?? ""
        let today = DateUtils.shared.getTodayString()
        
        var activity = ActivityRecord(title: title, content: content, type: activityType, date: today)
        activity.images = mediaPaths
        
        if let videoURL = selectedVideoURL {
            if let savedPath = saveVideoToDocuments(videoURL) {
                activity.video = savedPath
            }
        }
        
        activityRecordRepository.addActivityRecord(activity)
        
        EventCenter.shared.post(AppConfig.EVENT_REFRESH_HOME_DATA)
        EventCenter.shared.post(AppConfig.EVENT_REFRESH_PUBLISH_COUNTS)
        
        delegate?.activityAdded()
        navigationController?.popViewController(animated: true)
    }
    
    private func saveImageToDocuments(_ image: UIImage) -> String? {
        return ImageCacheManager.shared.saveImageToDocuments(image, filename: UUID().uuidString + ".jpg")
    }
    
    private func saveVideoToDocuments(_ url: URL) -> String? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(UUID().uuidString + ".mp4")
        
        do {
            try FileManager.default.copyItem(at: url, to: destinationURL)
            return destinationURL.path
        } catch {
            print("Error saving video: \(error)")
            return nil
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

extension AddActivityViewController: MediaPickerDelegate {
    func didPickImages(_ images: [UIImage]) {
        selectedImages.append(contentsOf: images)
        
        for image in images {
            if let path = saveImageToDocuments(image) {
                mediaPaths.append(path)
            }
        }
        
        mediaCollectionView.isHidden = selectedImages.isEmpty
        mediaCollectionView.reloadData()
    }
    
    func didPickVideo(_ url: URL) {
        selectedVideoURL = url
        
        ImageCacheManager.shared.generateThumbnail(from: url) { [weak self] thumbnail in
            if let thumbnail = thumbnail {
                self?.selectedImages = [thumbnail]
                self?.mediaCollectionView.isHidden = false
                self?.mediaCollectionView.reloadData()
            }
        }
    }
    
    func didCancel() {
    }
}

extension AddActivityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
        cell.configure(with: selectedImages[indexPath.item])
        return cell
    }
}

class MediaCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
