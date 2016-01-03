//
//  STCycleLoadView.swift
//  STCycleLoadView-ZhiHu
//
//  Created by TangJR on 1/3/16.
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

class STCycleLoadView: UIView {
    
    private let cycleLayer: CAShapeLayer = CAShapeLayer()
    private var isAnimation: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateUI()
    }
}

extension STCycleLoadView {
    private func setupUI() {
        cycleLayer.lineCap = "round"
        cycleLayer.lineJoin = "round"
        cycleLayer.lineWidth = STConfiguration.LineWidth
        cycleLayer.fillColor = UIColor.clearColor().CGColor
        cycleLayer.strokeColor = STConfiguration.MainColor.CGColor
        cycleLayer.strokeEnd = 0
        layer.addSublayer(cycleLayer)
    }
    
    private func updateUI() {
        cycleLayer.frame = bounds
        cycleLayer.path = UIBezierPath(ovalInRect: bounds).CGPath
    }
}

extension STCycleLoadView {
    func startAnimation() {
        guard !isAnimation else {
            return
        }
        isAnimation = true
        self.alpha = 1

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -1
        strokeStartAnimation.toValue = 1.2
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = STConfiguration.AnimationDuration
        animationGroup.repeatCount = Float.infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        cycleLayer.addAnimation(animationGroup, forKey: "animationGroup")
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = M_PI * 2
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.duration = STConfiguration.AnimationDuration * 4
        cycleLayer.addAnimation(rotateAnimation, forKey: "rotateAnimation")
    }
    
    func stopAnimation() {
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0
            }) { (finish) -> Void in
                self.cycleLayer.removeAllAnimations()
                self.isAnimation = false
        }
    }
}