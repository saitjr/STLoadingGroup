//
//  STPacManLoading.swift
//  STLoadingGroup
//
//  Created by saitjr on 2/22/17.
//  Copyright © 2017 saitjr. All rights reserved.
//

import UIKit

class STPacManLoading: UIView {
    internal var isLoading: Bool = false
    
    fileprivate var cycleGroup: [CAShapeLayer] = []
    fileprivate var cyclePaths: [UIBezierPath] = []
    
    fileprivate let cycleCount: Int = 4
    fileprivate let squreColor: UIColor = UIColor(red: 11 / 255.0, green: 12 / 255.0, blue: 16 / 255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateUI()
        
//        let colors: [UIColor] = [.red, .blue, .white, .green]
//        
//        for i in 0..<4 {
//            let line = CAShapeLayer()
//            line.path = cyclePaths[i].cgPath
//            line.strokeColor = colors[i].cgColor
//            layer.addSublayer(line)
//        }
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

extension STPacManLoading {
    fileprivate func setupUI() {
        for i in 0..<cycleCount {
            let cycle = CAShapeLayer()
            cycle.frame = CGRect.zero
            cycle.cornerRadius = lineWidth * 0.5
            cycle.masksToBounds = true
//            cycle.backgroundColor = loadingTintColor.cgColor
            cycle.fillColor = UIColor.clear.cgColor
            cycle.strokeColor = loadingTintColor.cgColor
            cycle.lineWidth = lineWidth
            layer.addSublayer(cycle)
            cycleGroup.append(cycle)
            
            let cycleSize = CGSize(width: lineWidth, height: lineWidth)
            let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: cycleSize))
            cycle.path = path.cgPath
            
            cycle.strokeStart = 0.25
            cycle.strokeEnd = 1
            
            cycle.transform = CATransform3DMakeRotation(CGFloat(Double.pi_2 * Double(i)), 0, 0, 1)
        }
    }
    
    fileprivate func updateUI() {
        let cycleSize = CGSize(width: lineWidth, height: lineWidth)
        let selfWidthSubCycleWidth = bounds.size.width - lineWidth
        let arcCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let halfCycleWidth = lineWidth * 0.5
        let leftConerPoint = CGPoint(x: halfCycleWidth, y: halfCycleWidth)
        let radius = sqrt(pow(arcCenter.x - leftConerPoint.x, 2) + pow(arcCenter.y - leftConerPoint.y, 2))
        
        for i in 0..<cycleCount {
            let cycle = cycleGroup[i]
            
            switch i {
            case 0:
                cycle.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: cycleSize)
            case 1:
                cycle.frame = CGRect(origin: CGPoint(x: selfWidthSubCycleWidth, y: 0), size: cycleSize)
            case 2:
                cycle.frame = CGRect(origin: CGPoint(x: selfWidthSubCycleWidth, y: selfWidthSubCycleWidth), size: cycleSize)
            case 3:
                cycle.frame = CGRect(origin: CGPoint(x: 0, y: selfWidthSubCycleWidth), size: cycleSize)
            default:
                cycle.frame = CGRect.zero
            }
        }
        let cycle1 = cycleGroup[0]
        let cycle2 = cycleGroup[1]
        let cycle3 = cycleGroup[2]
        let cycle4 = cycleGroup[3]
        
        let controlPoint1 = CGPoint(x: arcCenter.x, y: arcCenter.y - radius)
        let controlPoint2 = CGPoint(x: arcCenter.x + radius, y: arcCenter.y)
        let controlPoint3 = CGPoint(x: arcCenter.x, y: arcCenter.y + radius)
        let controlPoint4 = CGPoint(x: arcCenter.x - radius, y: arcCenter.y)
        
        let path1 = addQuadCurve(fromPoint: cycle1.position, toPoint: cycle2.position, controlPoint: controlPoint1)
        let path2 = addQuadCurve(fromPoint: cycle2.position, toPoint: cycle3.position, controlPoint: controlPoint2)
        let path3 = addQuadCurve(fromPoint: cycle3.position, toPoint: cycle4.position, controlPoint: controlPoint3)
        let path4 = addQuadCurve(fromPoint: cycle4.position, toPoint: cycle1.position, controlPoint: controlPoint4)
        
        cyclePaths = [path1, path2, path3, path4]
    }
    
    private func addQuadCurve(fromPoint: CGPoint, toPoint: CGPoint, controlPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addQuadCurve(to: toPoint, controlPoint: controlPoint)
        return path
    }
}

extension STPacManLoading: STLoadingConfig {
    var animationDuration: TimeInterval {
        return 1.5
    }
    
    var lineWidth: CGFloat {
        return 22.0
    }
    
    var loadingTintColor: UIColor {
        return .white
    }
}

extension STPacManLoading: STLoadingable {
    internal func startLoading() {
        guard !isLoading else {
            return
        }
        updateUI()
        isLoading = true
        
        for i in 0..<cycleCount {
            let cycle = cycleGroup[i]
            let cyclePath = cyclePaths[i]
            
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = Double.pi_2 * Double(i)
            rotateAnimation.toValue = Double.pi_2 * Double(i) + (-Double.pi_2 * 3)
            rotateAnimation.duration = animationDuration - 0.2
            
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            positionAnimation.path = cyclePath.cgPath
            positionAnimation.calculationMode = kCAAnimationPaced
            positionAnimation.duration = animationDuration - 0.2
            
            let animations = CAAnimationGroup()
            animations.duration = animationDuration
            animations.repeatCount = Float.infinity
            animations.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animations.animations = [positionAnimation, rotateAnimation]
            cycle.add(animations, forKey: "animations")
        }
    }
    
    internal func stopLoading(finish: STEmptyCallback?) {
        guard isLoading else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.isLoading = false
            for cycle in self.cycleGroup {
                cycle.removeAllAnimations()
            }
            finish?()
        })
    }
}
