//
//  STTriangleLoading.swift
//  STLoadingGroup
//
//  Created by saitjr on 1/9/17.
//  Copyright © 2017 saitjr. All rights reserved.
//

import UIKit

class STTriangleLoading: UIView {
    
    internal var isLoading: Bool = false

    fileprivate var spotGroup: [CAShapeLayer] = []
    fileprivate let spotCount: Int = 3
    
    fileprivate var topPoint: CGPoint {
        return CGPoint(x: height * 0.5, y: topPadding)
    }
    
    fileprivate var leftPoint: CGPoint {
        return CGPoint(x: leftPadding, y: 3 * height / 4 + topPadding)
    }
    
    fileprivate var rightPoint: CGPoint {
        return CGPoint(x: height - 2 * leftPadding, y: leftPoint.y)
    }
    
    fileprivate var points: [CGPoint] {
        return [leftPoint, topPoint, rightPoint]
    }
    
    private var height: CGFloat {
        return frame.size.height
    }
    
    private var leftPadding: CGFloat {
        return height * 0.5 - sqrt(3) * height * 0.25
    }
    
    private var topPadding: CGFloat {
        return height / 8 + halfLineWidth
    }
    
    private var halfLineWidth: CGFloat {
        return lineWidth * 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateUI()
    }
}

extension STTriangleLoading {
    fileprivate func setupUI() {
        for _ in 0 ..< spotCount {
            let spotLayer = CAShapeLayer()
            spotLayer.bounds = CGRect(x: 0, y: 0, width: lineWidth, height: lineWidth)
            spotLayer.path = UIBezierPath(ovalIn: spotLayer.bounds).cgPath
            spotLayer.fillColor = loadingTintColor.cgColor
            spotLayer.strokeColor = loadingTintColor.cgColor
            layer.addSublayer(spotLayer)
            spotGroup.append(spotLayer)
        }
    }
    
    fileprivate func updateUI() {
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            spotLayer.position = points[i]
        }
    }
}

extension STTriangleLoading: STLoadingConfig {
    var animationDuration: TimeInterval {
        return 0.7
    }
    
    var lineWidth: CGFloat {
        return 8
    }
    
    var loadingTintColor: UIColor {
        return .white
    }
}

extension STTriangleLoading: STLoadingable {
    internal func startLoading() {
        guard !isLoading else {
            return
        }
        updateUI()
        isLoading = true
        alpha = 1
        
        let toPoints: [CGPoint] = [topPoint, rightPoint, leftPoint]
        
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            let positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.toValue = toPoints[i]
            positionAnimation.duration = animationDuration
            positionAnimation.repeatCount = Float.infinity
            spotLayer.add(positionAnimation, forKey: "positionAnimation")
        }
    }
    
    internal func stopLoading(finish: STEmptyCallback? = nil) {
        guard isLoading else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.isLoading = false
            for spotLayer in self.spotGroup {
                spotLayer.removeAllAnimations()
            }
            finish?()
        })
    }
}
