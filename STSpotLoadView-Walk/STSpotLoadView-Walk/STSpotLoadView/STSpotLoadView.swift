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

class STSpotLoadView: UIView {
    
    private var spotGroup = [CAShapeLayer]()
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
        for _ in 0 ..< STConfiguration.SpotCount {
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
        for i in 0 ..< STConfiguration.SpotCount {
            let spotLayer = spotGroup[i]
            spotLayer.position = CGPointMake(CGFloat(i) * CGRectGetWidth(bounds) / CGFloat(STConfiguration.SpotCount - 1), CGRectGetHeight(bounds) / 2.0)
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
        
        let spotLayer1 = spotGroup[0]
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = UIBezierPath(arcCenter: CGPointMake(CGRectGetWidth(bounds) / 2.0, CGRectGetHeight(bounds) / 2.0), radius: CGRectGetWidth(bounds) / 2.0, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true).CGPath
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.duration = STConfiguration.AnimationDuration
        pathAnimation.repeatCount = Float.infinity
        spotLayer1.addAnimation(pathAnimation, forKey: "pathAnimation")
        
        for i in 1 ..< STConfiguration.SpotCount {
            let spotLayer = spotGroup[i]
            let positionAnimation = CABasicAnimation(keyPath: "position.x")
            positionAnimation.toValue = spotLayer.position.x - CGRectGetWidth(bounds) / CGFloat(STConfiguration.SpotCount - 1)
            positionAnimation.duration = STConfiguration.AnimationDuration
            positionAnimation.repeatCount = Float.infinity
            spotLayer.addAnimation(positionAnimation, forKey: "positionAnimation")
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