//
//  CircleProgressBar.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  圆形进度条视图
//

import UIKit

class CircleProgressBar: UIView {
    
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let label = UILabel()
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    var lineWidth: CGFloat = 10 {
        didSet {
            updatePath()
        }
    }
    
    var progressColor: UIColor = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0) {
        didSet {
            updateColors()
        }
    }
    
    var trackColor: UIColor = UIColor.lightGray.withAlphaComponent(0.3) {
        didSet {
            updateColors()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = trackColor.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        layer.addSublayer(backgroundLayer)
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        progressLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        layer.addSublayer(progressLayer)
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .darkGray
        addSubview(label)
        
        updatePath()
        updateColors()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
        
        label.frame = bounds
    }
    
    private func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        
        backgroundLayer.lineWidth = lineWidth
        progressLayer.lineWidth = lineWidth
    }
    
    private func updateColors() {
        backgroundLayer.strokeColor = trackColor.cgColor
        progressLayer.strokeColor = progressColor.cgColor
    }
    
    private func updateProgress() {
        let clampedProgress = min(max(progress, 0), 1)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = clampedProgress
        CATransaction.commit()
        
        label.text = "\(Int(clampedProgress * 100))"
        
        updateColorBasedOnProgress(clampedProgress)
    }
    
    private func updateColorBasedOnProgress(_ progress: CGFloat) {
        let score = progress * 100
        
        let color: UIColor
        if score >= 90 {
            color = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 1.0)
        } else if score >= 80 {
            color = UIColor(red: 0.42, green: 0.78, blue: 0.44, alpha: 1.0)
        } else if score >= 60 {
            color = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)
        } else if score >= 30 {
            color = UIColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.0)
        } else {
            color = UIColor(red: 0.85, green: 0.20, blue: 0.20, alpha: 1.0)
        }
        
        progressColor = color
        label.textColor = color
    }
    
    func setProgress(_ progress: CGFloat, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = progress
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            progressLayer.add(animation, forKey: "progressAnimation")
            progressLayer.strokeEnd = progress
        } else {
            self.progress = progress
        }
    }
    
    func animateProgress(to newProgress: CGFloat, duration: TimeInterval = 1.0) {
        let oldProgress = progress
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = oldProgress
        animation.toValue = newProgress
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        progressLayer.add(animation, forKey: "progressAnimation")
        progress = newProgress
    }
}
