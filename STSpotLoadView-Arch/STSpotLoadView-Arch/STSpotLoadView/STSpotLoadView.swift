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

class STSpotLoadView: UIView {
    
    private let spotCount = 3
    private var spotGroup = [CAShapeLayer]()
    private var shadowGroup = [CALayer]()
    private var isAnimation = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

extension STSpotLoadView {
    private func setupUI() {
        for _ in 0 ..< spotCount {
            let spotLayer = CAShapeLayer()
            spotLayer.lineCap = "round"
            spotLayer.lineJoin = "round"
            spotLayer.lineWidth = STConfiguration.LineWidth
            spotLayer.fillColor = UIColor.clearColor().CGColor
            spotLayer.strokeColor = STConfiguration.MainColor.CGColor
            spotLayer.strokeEnd = 0.000001
            layer.addSublayer(spotLayer)
            spotGroup.append(spotLayer)
            
            spotLayer.shadowColor = UIColor.blackColor().CGColor
            spotLayer.shadowOffset = CGSizeMake(10, 10)
            spotLayer.shadowOpacity = 0.2
            spotLayer.shadowRadius = 10
        }
    }
    
    private func updateUI() {
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            let spotWidth = CGRectGetWidth(bounds) * CGFloat((spotCount - i)) * 0.6
            spotLayer.bounds = CGRectMake(0, 0, spotWidth, spotWidth)
            spotLayer.position = CGPointMake(CGRectGetWidth(bounds) * 1.1, CGRectGetHeight(bounds) / 2.0)
            spotLayer.path = UIBezierPath(arcCenter: CGPointMake(spotWidth / 2.0 - CGRectGetWidth(bounds) * 0.3, spotWidth / 2.0), radius: spotWidth * 0.25, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI * 2), clockwise: true).CGPath
        }
    }
}

extension STSpotLoadView {
    func startAnimation() {
        guard !isAnimation else {
            return
        }
        isAnimation = true
        alpha = 1
        
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            
            let transformAnimation = CABasicAnimation(keyPath: "position.x")
            transformAnimation.fromValue = CGRectGetWidth(bounds) * 1.1
            transformAnimation.toValue = CGRectGetWidth(bounds) * 0.5
            transformAnimation.duration = STConfiguration.AnimationDuration
            transformAnimation.fillMode = "forwards"
            transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            transformAnimation.removedOnCompletion = false
            
            let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeEndAnimation.fromValue = 0
            strokeEndAnimation.toValue = 1
            
            let strokeStartAniamtion = CABasicAnimation(keyPath: "strokeStart")
            strokeStartAniamtion.fromValue = -1
            strokeStartAniamtion.toValue = 1
            
            let strokeAnimationGroup = CAAnimationGroup()
            strokeAnimationGroup.duration = (STConfiguration.AnimationDuration - NSTimeInterval(3 - i) * STConfiguration.AnimationDuration * 0.1) * 0.8
            strokeAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            strokeAnimationGroup.fillMode = "forwards"
            strokeAnimationGroup.removedOnCompletion = false
            strokeAnimationGroup.animations = [strokeStartAniamtion, strokeEndAnimation]
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = STConfiguration.AnimationDuration
            animationGroup.repeatCount = Float.infinity
            animationGroup.animations = [transformAnimation, strokeAnimationGroup]
            spotLayer.addAnimation(animationGroup, forKey: "animationGroup")
        }
    }
    
    func stopAnimation() {
        guard isAnimation else {
            return
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0
            }) { (finish) -> Void in
                self.isAnimation = false
                for spotLayer in self.spotGroup {
                    spotLayer.removeAllAnimations()
                }
        }
    }
}