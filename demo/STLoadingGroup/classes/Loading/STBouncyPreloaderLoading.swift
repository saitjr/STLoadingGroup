//
//  STSpotLoadView.swift
//  STSpotLoadView-BouncyPreloader
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

class STBouncyPreloaderLoading: UIView {
    
    fileprivate let spotLayer: CAShapeLayer = CAShapeLayer()
    fileprivate let spotReplicatorLayer: CAReplicatorLayer = CAReplicatorLayer()
    fileprivate let spotCount = 3
    
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

extension STBouncyPreloaderLoading {
    internal func setupUI() {
        self.alpha = 0
        
        spotLayer.frame = CGRect(x: 0, y: 0, width: lineWidth, height: lineWidth)
        spotLayer.lineCap = kCALineCapRound
        spotLayer.lineJoin = kCALineJoinRound
        spotLayer.lineWidth = lineWidth
        spotLayer.fillColor = loadingTintColor.cgColor
        spotLayer.strokeColor = loadingTintColor.cgColor
        spotLayer.path = UIBezierPath(ovalIn: spotLayer.bounds).cgPath
        spotReplicatorLayer.addSublayer(spotLayer)
        
        spotReplicatorLayer.instanceCount = spotCount
        spotReplicatorLayer.instanceDelay = animationDuration / 5
        layer.addSublayer(spotReplicatorLayer)
    }
    
    internal func updateUI() {
        spotLayer.frame = CGRect(x: lineWidth / 2.0, y: (bounds.height - lineWidth) / 2.0, width: lineWidth, height: lineWidth)
        spotReplicatorLayer.frame = bounds
        spotReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(bounds.width / CGFloat(spotCount), 0, 0)
    }
}

extension STBouncyPreloaderLoading: STLoadingConfig {
    var animationDuration: TimeInterval {
        return 0.5
    }
    
    var lineWidth: CGFloat {
        return 4
    }
    
    var loadingTintColor: UIColor {
        return .white
    }
}

extension STBouncyPreloaderLoading: STLoadingable {
    internal func startLoading() {
        guard !isLoading else {
            return
        }
        isLoading = true
        
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.alpha = 1
        }
        
        let centerY = bounds.height / 2.0
        let downY = centerY + 15.0
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position.y")
        positionAnimation.beginTime = CACurrentMediaTime() + 0.5
        positionAnimation.values = [centerY, downY, centerY, centerY]
        positionAnimation.keyTimes = [0.0, 0.33, 0.63, 1.0]
        positionAnimation.repeatCount = Float.infinity
        positionAnimation.duration = animationDuration + 0.4
        spotLayer.add(positionAnimation, forKey: "positionAnimation")
    }
    
    internal func stopLoading(finish: STEmptyCallback? = nil) {
        guard isLoading else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: { 
            self.alpha = 0
        }, completion: { _ in
            self.isLoading = false
            self.spotLayer.removeAllAnimations()
            
            finish?()
        })
    }
}
