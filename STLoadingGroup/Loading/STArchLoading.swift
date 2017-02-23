//
//  STSpotLoadView.swift
//  STSpotLoadView-Arch
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

class STArchLoading: UIView {
    
    fileprivate let spotCount = 3
    fileprivate var spotGroup: [CAShapeLayer] = []
    fileprivate var shadowGroup: [CALayer] = []
    
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

extension STArchLoading {
    fileprivate func setupUI() {
        for _ in 0 ..< spotCount {
            let spotLayer = CAShapeLayer()
            spotLayer.lineCap = "round"
            spotLayer.lineJoin = "round"
            spotLayer.lineWidth = lineWidth
            spotLayer.fillColor = UIColor.clear.cgColor
            spotLayer.strokeColor = loadingTintColor.cgColor
            spotLayer.strokeEnd = 0.000001
            layer.addSublayer(spotLayer)
            spotGroup.append(spotLayer)

            spotLayer.shadowColor = UIColor.black.cgColor
            spotLayer.shadowOffset = CGSize(width: 10, height: 10)
            spotLayer.shadowOpacity = 0.2
            spotLayer.shadowRadius = 10
        }
    }
    
    fileprivate func updateUI() {
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            let spotWidth = bounds.width * CGFloat((spotCount - i)) * 0.6
            spotLayer.bounds = CGRect(x: 0, y: 0, width: spotWidth, height: spotWidth)
            spotLayer.position = CGPoint(x: bounds.width * 1.1, y: bounds.height / 2.0)
            spotLayer.path = UIBezierPath(arcCenter: CGPoint(x: spotWidth / 2.0 - bounds.width * 0.3, y: spotWidth / 2.0), radius: spotWidth * 0.25, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: true).cgPath
        }
    }
}

extension STArchLoading: STLoadingConfig {
    var animationDuration: TimeInterval {
        return 1
    }
    
    var lineWidth: CGFloat {
        return 8
    }
    
    var loadingTintColor: UIColor {
        return .white
    }
}

extension STArchLoading: STLoadingable {
    internal func startLoading() {
        guard !isLoading else {
            return
        }
        isLoading = true
        alpha = 1
        
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            
            let transformAnimation = CABasicAnimation(keyPath: "position.x")
            transformAnimation.fromValue = bounds.width * 1.1
            transformAnimation.toValue = bounds.width * 0.5
            transformAnimation.duration = animationDuration
            transformAnimation.fillMode = kCAFillModeForwards
            transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            transformAnimation.isRemovedOnCompletion = false
            
            let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeEndAnimation.fromValue = 0
            strokeEndAnimation.toValue = 1
            
            let strokeStartAniamtion = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAniamtion.fromValue = -1
            strokeStartAniamtion.toValue = 1
            
            let strokeAnimationGroup = CAAnimationGroup()
            strokeAnimationGroup.duration = (animationDuration - TimeInterval(3 - i) * animationDuration * 0.1) * 0.8
            strokeAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            strokeAnimationGroup.fillMode = kCAFillModeForwards
            strokeAnimationGroup.isRemovedOnCompletion = false
            strokeAnimationGroup.animations = [strokeStartAniamtion, strokeEndAnimation]
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = animationDuration
            animationGroup.repeatCount = Float.infinity
            animationGroup.animations = [transformAnimation, strokeAnimationGroup]
            spotLayer.add(animationGroup, forKey: "animationGroup")
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
