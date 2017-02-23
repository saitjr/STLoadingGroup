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

class STZhiHuLoading: UIView {
    
    fileprivate let cycleLayer: CAShapeLayer = CAShapeLayer()
    
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

extension STZhiHuLoading {
    fileprivate func setupUI() {
        cycleLayer.lineCap = kCALineCapRound
        cycleLayer.lineJoin = kCALineJoinRound
        cycleLayer.lineWidth = lineWidth
        cycleLayer.fillColor = UIColor.clear.cgColor
        cycleLayer.strokeColor = loadingTintColor.cgColor
        cycleLayer.strokeEnd = 0
        layer.addSublayer(cycleLayer)
    }
    
    fileprivate func updateUI() {
        cycleLayer.frame = bounds
        cycleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
    }
}

extension STZhiHuLoading: STLoadingConfig {
    var animationDuration: TimeInterval {
        return 1
    }
    
    var lineWidth: CGFloat {
        return 4
    }
    
    var loadingTintColor: UIColor {
        return .white
    }
}

extension STZhiHuLoading: STLoadingable {
    internal func startLoading() {
        guard !isLoading else {
            return
        }
        isLoading = true
        self.alpha = 1

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -1
        strokeStartAnimation.toValue = 1.0

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = Float.infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        cycleLayer.add(animationGroup, forKey: "animationGroup")
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = M_PI * 2
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.duration = animationDuration * 4
        cycleLayer.add(rotateAnimation, forKey: "rotateAnimation")
    }
    
    internal func stopLoading(finish: STEmptyCallback? = nil) {
        guard isLoading else {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.alpha = 0
        }, completion: { _ in
            self.cycleLayer.removeAllAnimations()
            self.isLoading = false
            finish?()
        })
    }
}
