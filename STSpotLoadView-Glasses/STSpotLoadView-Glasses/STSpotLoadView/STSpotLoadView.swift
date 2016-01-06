//
//  STSpotLoadView.swift
//  STSpotLoadView-Glasses
//
//  Created by TangJR on 1/6/16.
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

    private var spotGroup = [CAShapeLayer]()
    private var isAnimation = false
    private let spotCount: Int = 3
    
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
            spotLayer.bounds = CGRectMake(0, 0, STConfiguration.SpotDiameter, STConfiguration.SpotDiameter)
            spotLayer.path = UIBezierPath(ovalInRect: spotLayer.bounds).CGPath
            spotLayer.fillColor = STConfiguration.MainColor.CGColor
            spotLayer.strokeColor = STConfiguration.MainColor.CGColor
            layer.addSublayer(spotLayer)
            spotGroup.append(spotLayer)
        }
    }
    
    private func updateUI() {
        for i in 0 ..< spotCount {
            let spotLayer = spotGroup[i]
            spotLayer.position = CGPointMake(CGFloat(i) * CGRectGetWidth(bounds) / CGFloat(spotCount - 1), CGRectGetHeight(bounds) / 2.0)
        }
    }
}

extension STSpotLoadView {
    private func generalGroupAnimation(path: UIBezierPath, needRmoveOnCompletion: Bool, beginTime: CFTimeInterval) -> CAAnimationGroup {
        let pathToLeftAnimation = CAKeyframeAnimation(keyPath: "position")
        pathToLeftAnimation.path = path.CGPath
        pathToLeftAnimation.calculationMode = "paced"
        pathToLeftAnimation.duration = STConfiguration.AnimationDuration / 2.0
        if needRmoveOnCompletion {
            pathToLeftAnimation.fillMode = "forwards"
            pathToLeftAnimation.removedOnCompletion = false
        }
        
        let delayGroupAnimation = CAAnimationGroup()
        delayGroupAnimation.animations = [pathToLeftAnimation]
        delayGroupAnimation.duration = STConfiguration.AnimationDuration
        delayGroupAnimation.repeatCount = Float.infinity
        
        if beginTime != 0 {
            delayGroupAnimation.beginTime = CACurrentMediaTime() + beginTime
        }
        
        return delayGroupAnimation
    }
}

extension STSpotLoadView {
    func startAnimation() {
        guard !isAnimation else {
            return
        }
        isAnimation = true
        alpha = 1
        
        let spotLayer1 = spotGroup[0] as CAShapeLayer
        let spotLayer2 = spotGroup[1] as CAShapeLayer
        let spotLayer3 = spotGroup[2] as CAShapeLayer
        
        let radius = CGRectGetWidth(bounds) / CGFloat(spotCount - 1) / 2
        let arcCenterLeft = CGPointMake(radius, CGRectGetMidY(spotLayer1.frame))
        let arcCenterRight = CGPointMake(CGRectGetWidth(bounds) - radius, arcCenterLeft.y)
        
        let pathToRight1 = UIBezierPath(arcCenter: arcCenterLeft, radius: radius, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        let pathToRight2 = UIBezierPath(arcCenter: arcCenterRight, radius: radius, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
        pathToRight1.appendPath(pathToRight2)
        
        let pathToRightAnimation1 = CAKeyframeAnimation(keyPath: "position")
        pathToRightAnimation1.path = pathToRight1.CGPath
        pathToRightAnimation1.calculationMode = "paced"
        pathToRightAnimation1.duration = STConfiguration.AnimationDuration
        pathToRightAnimation1.repeatCount = Float.infinity
        spotLayer1.addAnimation(pathToRightAnimation1, forKey: "pathToRightAnimation1")
        
        let pathToLeft1 = UIBezierPath(arcCenter: arcCenterLeft, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        let spot2Animation = generalGroupAnimation(pathToLeft1, needRmoveOnCompletion: true, beginTime: 0)
        spotLayer2.addAnimation(spot2Animation, forKey: "spot2Animation")
        
        let pathToLeft2 = UIBezierPath(arcCenter: arcCenterRight, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        let spot3Animation = generalGroupAnimation(pathToLeft2, needRmoveOnCompletion: false, beginTime: STConfiguration.AnimationDuration / 2.0)
        spotLayer3.addAnimation(spot3Animation, forKey: "spot3Animation")
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