//
//  AnimationExtensions.swift
//  SelfImprovement
//
//  Created on 2026/3/5.
//  动画扩展
//

import UIKit

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }) { _ in
            completion?()
        }
    }
    
    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            completion?()
        }
    }
    
    func slideIn(from edge: UIRectEdge, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        let originalFrame = frame
        
        switch edge {
        case .left:
            frame.origin.x = -frame.width
        case .right:
            frame.origin.x = superview?.frame.width ?? frame.width
        case .top:
            frame.origin.y = -frame.height
        case .bottom:
            frame.origin.y = superview?.frame.height ?? frame.height
        default:
            break
        }
        
        isHidden = false
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.frame = originalFrame
        }) { _ in
            completion?()
        }
    }
    
    func slideOut(to edge: UIRectEdge, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        let originalFrame = frame
        var targetFrame = frame
        
        switch edge {
        case .left:
            targetFrame.origin.x = -frame.width
        case .right:
            targetFrame.origin.x = superview?.frame.width ?? frame.width
        case .top:
            targetFrame.origin.y = -frame.height
        case .bottom:
            targetFrame.origin.y = superview?.frame.height ?? frame.height
        default:
            break
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.frame = targetFrame
        }) { _ in
            self.frame = originalFrame
            self.isHidden = true
            completion?()
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
    
    func pulse(scale: CGFloat = 1.1, duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: duration) {
                self.transform = .identity
            }
        }
    }
    
    func bounce() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
    func rotate(duration: TimeInterval = 0.5) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = 1
        layer.add(rotation, forKey: "rotationAnimation")
    }
}

extension UILabel {
    
    func animateTextChange(to newText: String, duration: TimeInterval = 0.3) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.text = newText
        })
    }
    
    func typewriterEffect(text: String, duration: TimeInterval = 1.0) {
        self.text = ""
        
        let characters = Array(text)
        let delay = duration / Double(characters.count)
        
        for (index, character) in characters.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(index)) {
                self.text?.append(character)
            }
        }
    }
}

extension UIButton {
    
    func animatePress() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
}

extension UITableViewCell {
    
    func animateSelection() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor(red: 0.29, green: 0.69, blue: 0.31, alpha: 0.3).cgColor
        animation.toValue = backgroundColor?.cgColor
        animation.duration = 0.3
        layer.add(animation, forKey: "selectionAnimation")
    }
}
