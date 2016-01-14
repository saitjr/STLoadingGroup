//
//  STCycleLoadView.swift
//  STCycleLoadView-SubmitButton
//
//  Created by TangJR on 1/4/16.
//  Copyright © 2016. All rights reserved.
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
        cycleLayer.bounds = bounds
        cycleLayer.position = CGPointMake(CGRectGetWidth(bounds) / 2.0, CGRectGetHeight(bounds) / 2.0)
        cycleLayer.path = UIBezierPath(ovalInRect: bounds).CGPath
    }
}

extension STCycleLoadView: STAnimationProtocol {
    func startAnimation() {
        guard !isAnimation else {
            return
        }
        isAnimation = true
        
        self.alpha = 1
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 0.25
        strokeEndAnimation.fillMode = "forwards"
        strokeEndAnimation.removedOnCompletion = false
        strokeEndAnimation.duration = STConfiguration.AnimationDuration / 4.0
        cycleLayer.addAnimation(strokeEndAnimation, forKey: "strokeEndAnimation")
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = M_PI * 2
        rotateAnimation.duration = STConfiguration.AnimationDuration
        rotateAnimation.beginTime = CACurrentMediaTime() + strokeEndAnimation.duration
        rotateAnimation.repeatCount = Float.infinity
        cycleLayer.addAnimation(rotateAnimation, forKey: "rotateAnimation")
    }
    
    func stopAnimation() {
        guard isAnimation else {
            return
        }
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.fillMode = "forwards"
        strokeEndAnimation.removedOnCompletion = false
        strokeEndAnimation.duration = STConfiguration.AnimationDuration * 3.0 / 4.0
        cycleLayer.addAnimation(strokeEndAnimation, forKey: "catchStrokeEndAnimation")
        
        UIView.animateWithDuration(0.3, delay: strokeEndAnimation.duration, options: .CurveEaseInOut, animations: { () -> Void in
            self.alpha = 0
            }) { (finish) -> Void in
                self.cycleLayer.removeAllAnimations()
                self.isAnimation = false
        }
    }
}