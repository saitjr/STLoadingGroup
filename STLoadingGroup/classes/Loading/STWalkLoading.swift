//
//  STSpotLoadView.swift
//  STSpotLoadView-Walk
//
//  Created by TangJR on 1/4/16.
//  Copyright © 2016 tangjr. All rights reserved.
//

/*
The MIT License (MIT)

Copyright (c) 2016 saitjr

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit

class STWalkLoading: UIView {
    
    fileprivate var spotGroup: [CAShapeLayer] = []
    fileprivate let spotCount = 4
    
    internal var isLoading: Bool = false
    
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

extension STWalkLoading {
    internal func setupUI() {
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
    
    internal func updateUI() {
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            spotLayer.position = CGPoint(x: CGFloat(i) * bounds.width / CGFloat(spotCount - 1), y: bounds.height / 2.0)
        }
    }
}

extension STWalkLoading: STLoadingConfig {
    var animationDuration: TimeInterval {
        return 0.5
    }
    
    var lineWidth: CGFloat {
        return 8
    }
    
    var loadingTintColor: UIColor {
        return .white
    }
}

extension STWalkLoading: STLoadingable {
    internal func startLoading() {
        guard !isLoading else {
            return
        }
        updateUI()
        isLoading = true
        alpha = 1
        
        let spotLayer1 = spotGroup[0]
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0), radius: bounds.width / 2.0, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true).cgPath
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.duration = animationDuration
        pathAnimation.repeatCount = Float.infinity
        spotLayer1.add(pathAnimation, forKey: "pathAnimation")
        
        for i in 1 ..< spotCount {
            let spotLayer = spotGroup[i]
            let positionAnimation = CABasicAnimation(keyPath: "position.x")
            positionAnimation.toValue = spotLayer.position.x - bounds.width / CGFloat(spotCount - 1)
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
