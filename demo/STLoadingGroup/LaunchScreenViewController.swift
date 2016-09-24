//
//  LaunchScreenViewController.swift
//  STLoadingGroup
//
//  Created by saitjr on 9/22/16.
//  Copyright © 2016 saitjr. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
//    typealias EmptyBlock = ()->()
//    public var disappearCallback: EmptyBlock?
    
    fileprivate var labels: [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let imageView = UIImageView(image: UIImage(named: "LaunchScreen"))
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        labels = generateLabels(text: "Loading...")
        layoutLabels(labels: labels)
    }
    
    // debug animation
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for label in labels {
//            label.alpha = 0
//        }
//        animteLabels(labels: labels)
//    }
}

extension LaunchScreenViewController {
    internal func generateLabels(text: String) -> [UILabel] {
        var labels: [UILabel] = []
        for c in text.characters {
            let label = setupLabel(text: String(c))
            labels.append(label)
        }
        return labels
    }
    
    internal func setupLabel(text: String) -> UILabel {
        let font: UIFont = UIFont(name: "Arciform Sans", size: 30) ?? .systemFont(ofSize: 30)
        let label = UILabel()
        label.bounds.size = CGSize(width: 25, height: 40)
        label.center.x = view.center.x
        label.center.y = view.center.y - 20
        label.text = text
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.backgroundColor = UIColor(red: 33 / 255.0, green: 36 / 255.0, blue: 44 / 255.0, alpha: 0.6)
        label.textAlignment = .center
        label.font = font
        label.alpha = 0
        view.addSubview(label)
        return label
    }
    
    internal func layoutLabels(labels: [UILabel]) {
        let count: CGFloat = CGFloat(labels.count)
        let cardWidth: CGFloat = 25
        let spacing: CGFloat = 2
        let sumWidth = cardWidth * count + spacing * (count - 1)
        let originX = UIScreen.main.bounds.width * 0.5 - sumWidth * 0.5
        
        for (i, label) in labels.enumerated() {
            label.frame.origin.x = originX + CGFloat(i) * (cardWidth + spacing)
        }
        
        sleep(1)
        animteLabels(labels: labels)
    }
    
    internal func animteLabels(labels: [UILabel]) {
        var delay: TimeInterval = 0
        
        for (i, label) in labels.enumerated() {
            var offsetX: CGFloat = 50
            if i > labels.count / 2 {
                offsetX = offsetX * -1
            }
            let t = CGAffineTransform(scaleX: 0.5, y: 0.5).translatedBy(x: offsetX, y: 50)
            label.transform = t
            
            let duration: TimeInterval = 0.5 + TimeInterval(labels.count - i) * 0.04
            delay = delay + duration * 0.1
            
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                label.transform = CGAffineTransform.identity
                label.alpha = 1
            }, completion: { _ in
                if i == labels.count - 1 {
                    UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseInOut, animations: {
                        self.view.alpha = 0
                    }, completion: { _ in
                        self.view.removeFromSuperview()
                        self.removeFromParentViewController()
                    })
                }
            })
        }
    }
}

extension String {
    func size(font: UIFont) -> CGSize {
        return .zero
    }
}
