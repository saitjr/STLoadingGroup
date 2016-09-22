//
//  STLoadingGroup.swift
//  STLoadingGroup
//
//  Created by saitjr on 9/14/16.
//  Copyright © 2016 saitjr. All rights reserved.
//

import UIKit

enum STLoadingStyle: String {
    case submit = "submit"
    case glasses = "glasses"
    case walk = "walk"
    case arch = "arch"
    case bouncyPreloader = "bouncyPreloader"
    case zhihu = "zhihu"
}

struct STLoadingConfig {
    var lineWidth: CGFloat = 4
    var animationDuration: TimeInterval = 1
    var tintColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    init(lineWidth: CGFloat = 4, animationDuration: TimeInterval = 1, tintColor: UIColor = .white) {
        self.lineWidth = lineWidth
        self.animationDuration = animationDuration
        self.tintColor = tintColor
    }
}

class STLoadingGroup {
    fileprivate let loadingView: STLoadingable
    fileprivate let config: STLoadingConfig
    
    init(side: CGFloat, style: STLoadingStyle, config: STLoadingConfig = STLoadingConfig()) {
        self.config = config
        
        let bounds = CGRect(origin: .zero, size: CGSize(width: side, height: side))
        switch style {
        case .submit:
            loadingView = STSubmitLoading(frame: bounds, config: self.config)
        case .glasses:
            loadingView = STGlassesLoading(frame: bounds, config: self.config)
        case .walk:
            loadingView = STWalkLoading(frame: bounds, config: self.config)
        case .arch:
            loadingView = STArchLoading(frame: bounds, config: self.config)
        case .bouncyPreloader:
            loadingView = STBouncyPreloaderLoading(frame: bounds, config: self.config)
        case .zhihu:
            loadingView = STZhiHuLoading(frame: bounds, config: self.config)
        }
    }
}

extension STLoadingGroup {
    var isLoading: Bool {
        return loadingView.isLoading
    }
    
    func startLoading() {
        loadingView.startLoading()
    }
    
    func stopLoading() {
        loadingView.stopLoading()
    }
}

extension STLoadingGroup {
    func show(_ inView: UIView?, offset: CGPoint = .zero, autoHide: TimeInterval = 0) {
        guard let loadingView = loadingView as? UIView else {
            return
        }
        var showInView = UIApplication.shared.keyWindow ?? UIView()
        if let inView = inView {
            showInView = inView
        }
        let showInViewSize = showInView.frame.size
        loadingView.center = CGPoint(x: showInViewSize.width * 0.5, y: showInViewSize.height * 0.5)
        showInView.addSubview(loadingView)
    }
}
