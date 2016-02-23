//
//  STSubmitButton.swift
//  STSubmitButton
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

class STSubmitButton: UIButton {
    
    private let loadingLayer: CAShapeLayer = CAShapeLayer()
    private let hookView: UIView = UIView()
    private let hookLayer: CAShapeLayer = CAShapeLayer()
    private let tempView: UIView = UIView()
    private let originButton = UIButton()
    private var isAnimating: Bool = false
    
    private let titleScaleAnimationDuration: NSTimeInterval = 0.2
    private let scaleWidthAnimationDuration: NSTimeInterval = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTempView()
        setupLoadingLayer()
        setupHookView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupTempView()
        setupLoadingLayer()
        setupHookView()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateUI()
        saveButtonProperty()
    }
}

extension STSubmitButton {
    private func setupUI() {
        layer.borderColor = STConfiguration.MainColor.CGColor
        layer.borderWidth = STConfiguration.BorderWidth
        setTitleColor(titleColorForState(.Normal), forState: .Highlighted)
    }
    
    private func setupTempView() {
        tempView.layer.borderColor = layer.borderColor
        tempView.layer.borderWidth = layer.borderWidth
        tempView.backgroundColor = backgroundColor
        tempView.alpha = 0.0
        addSubview(tempView)
    }
    
    private func setupLoadingLayer() {
        loadingLayer.lineWidth = layer.borderWidth + 1
        loadingLayer.lineCap = "round"
        loadingLayer.lineJoin = "round"
        loadingLayer.fillColor = UIColor.clearColor().CGColor
        loadingLayer.strokeColor = STConfiguration.MainColor.CGColor
        loadingLayer.hidden = true
        layer.addSublayer(loadingLayer)
    }
    
    private func setupHookView() {
        hookLayer.lineWidth = layer.borderWidth + 1
        hookLayer.lineCap = "round"
        hookLayer.lineJoin = "round"
        hookLayer.fillColor = UIColor.clearColor().CGColor
        hookLayer.strokeColor = UIColor.whiteColor().CGColor
        hookView.layer.addSublayer(hookLayer)
        
        hookView.hidden = true
        hookView.transform = CGAffineTransformMakeScale(0.3, 0.3)
        addSubview(hookView)
    }
    
    private func updateUI() {
        layer.cornerRadius = CGRectGetHeight(bounds) / 2.0
        
        tempView.layer.cornerRadius = layer.cornerRadius
        tempView.frame = bounds
        
        loadingLayer.bounds = CGRectMake(0, 0, CGRectGetHeight(bounds) - STConfiguration.BorderWidth, CGRectGetHeight(bounds) - STConfiguration.BorderWidth)
        loadingLayer.position = tempView.center
        loadingLayer.path = UIBezierPath(ovalInRect: loadingLayer.bounds).CGPath
        
        hookView.bounds = loadingLayer.bounds
        hookView.center = loadingLayer.position
        hookLayer.bounds = loadingLayer.bounds
        hookLayer.position = CGPointMake(CGRectGetWidth(hookView.bounds) / 2.0, CGRectGetHeight(hookView.bounds) / 2.0)
        let hookPath = UIBezierPath()
        hookPath.moveToPoint(CGPointMake(CGRectGetHeight(bounds) / 2.0 - 10.0, CGRectGetHeight(bounds) / 2.0))
        hookPath.addLineToPoint(CGPointMake(CGRectGetHeight(bounds) / 2.0 - 3, CGRectGetHeight(bounds) / 2.0 + 7.0))
        hookPath.addLineToPoint(CGPointMake(CGRectGetHeight(bounds) / 2.0 + 10.0, CGRectGetHeight(bounds) / 2.0 - 10.0))
        hookLayer.path = hookPath.CGPath
    }
    
    private func saveButtonProperty() {
        originButton.backgroundColor = UIColor.whiteColor()
        originButton.setTitleColor(titleColorForState(.Normal), forState: .Normal)
        originButton.setTitleColor(titleColorForState(.Selected), forState: .Selected)
        originButton.frame = frame
    }
}

extension STSubmitButton {
    func startAnimation() {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        zoomInAnimation()
        loadingAnimation()
    }
    
    func stopAnimation() {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = STConfiguration.AnimationDuration * 3.0 / 4.0
        strokeEndAnimation.delegate = self
        loadingLayer.addAnimation(strokeEndAnimation, forKey: "strokeEndAnimation")
        isAnimating = false
    }
}

extension STSubmitButton {
    private func zoomInAnimation() {
        titleLabel?.transform = CGAffineTransformMakeScale(0.8, 0.8)
        tempView.alpha = 1
        tempView.hidden = false
        UIView.animateWithDuration(titleScaleAnimationDuration, animations: { () -> Void in
            self.titleLabel?.transform = CGAffineTransformIdentity
            }) { (finish) -> Void in
                self.layer.borderColor = UIColor.clearColor().CGColor
                self .setTitleColor(UIColor.clearColor(), forState: .Normal)
                self.backgroundColor = UIColor.whiteColor()
                self.tempView.backgroundColor = self.backgroundColor
        }
        UIView.animateWithDuration(scaleWidthAnimationDuration, delay: titleScaleAnimationDuration, options: .CurveLinear, animations: { () -> Void in
            self.tempView.bounds.size.width = CGRectGetHeight(self.originButton.bounds)
            self.tempView.center = CGPointMake(CGRectGetWidth(self.originButton.bounds) / 2.0, CGRectGetHeight(self.originButton.bounds) / 2.0)
            self.tempView.layer.borderColor = STConfiguration.LoadingCycleBackgroundColor.CGColor
            }) { (finish) -> Void in
                self.loadingLayer.hidden = false
        }
    }
    
    private func loadingAnimation() {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 0.25
        strokeEndAnimation.beginTime = CACurrentMediaTime() + titleScaleAnimationDuration + scaleWidthAnimationDuration
        strokeEndAnimation.duration = STConfiguration.AnimationDuration / 4.0
        strokeEndAnimation.fillMode = "forwards"
        strokeEndAnimation.removedOnCompletion = false
        loadingLayer.addAnimation(strokeEndAnimation, forKey: "loadingAnimationGroup")
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.beginTime = strokeEndAnimation.duration + strokeEndAnimation.beginTime
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = M_PI * 2
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.duration = STConfiguration.AnimationDuration
        loadingLayer.addAnimation(rotateAnimation, forKey: "rotateAnimation")
    }
    
    private func zoomOutAnimation() {
        loadingLayer.hidden = true
        tempView.alpha = 1
        hookView.hidden = false
        hookView.alpha = 0
        UIView.animateWithDuration(scaleWidthAnimationDuration, delay: 0, options: .CurveLinear, animations: { () -> Void in
            self.tempView.bounds.size.width = CGRectGetWidth(self.originButton.bounds)
            self.tempView.center = CGPointMake(CGRectGetWidth(self.originButton.bounds) / 2.0, CGRectGetHeight(self.originButton.bounds) / 2.0)
            self.tempView.layer.borderColor = STConfiguration.MainColor.CGColor
            self.tempView.backgroundColor = STConfiguration.MainColor
            self.hookView.alpha = 1
            self.hookView.transform = CGAffineTransformIdentity
            }) { (finish) -> Void in
                
        }
        UIView.animateWithDuration(0.5, delay: STConfiguration.StayHookDuration + scaleWidthAnimationDuration, options: .CurveLinear, animations: { () -> Void in
            self.hookView.alpha = 0
            self.tempView.backgroundColor = self.originButton.backgroundColor
            }) { (finish) -> Void in
                self.hookView.hidden = true
                self.tempView.hidden = true
                self.layer.borderColor = STConfiguration.MainColor.CGColor
                self.backgroundColor = self.originButton.backgroundColor
                self.setTitleColor(self.originButton.titleColorForState(.Normal), forState: .Normal)
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        loadingLayer.removeAllAnimations()
        zoomOutAnimation()
    }
}