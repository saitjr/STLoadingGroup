//
//  STLoadingGroup.swift
//  STLoadingGroup
//
//  Created by saitjr on 9/14/16.
//  Copyright © 2016 saitjr. All rights reserved.
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

enum STLoadingStyle: String {
    case submit = "submit"
    case glasses = "glasses"
    case walk = "walk"
    case arch = "arch"
    case bouncyPreloader = "bouncyPreloader"
    case zhihu = "zhihu"
    case triangle = "triangle"
}

class STLoadingGroup {
    fileprivate let loadingView: STLoadingable
    fileprivate var finish: STEmptyCallback?
    
    init(side: CGFloat, style: STLoadingStyle) {
        
        let bounds = CGRect(origin: .zero, size: CGSize(width: side, height: side))
        switch style {
        case .submit:
            loadingView = STSubmitLoading(frame: bounds)
        case .glasses:
            loadingView = STGlassesLoading(frame: bounds)
        case .walk:
            loadingView = STWalkLoading(frame: bounds)
        case .arch:
            loadingView = STArchLoading(frame: bounds)
        case .bouncyPreloader:
            loadingView = STBouncyPreloaderLoading(frame: bounds)
        case .zhihu:
            loadingView = STZhiHuLoading(frame: bounds)
        case .triangle:
            loadingView = STTriangleLoading(frame: bounds)
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
    
    func stopLoading(finish: STEmptyCallback? = nil) {
        self.finish = finish
        loadingView.stopLoading(finish: finish)
    }
}

extension STLoadingGroup {
    func show(_ inView: UIView?, offset: CGPoint = .zero, autoHide: TimeInterval = 0) {
        guard let loadingView = loadingView as? UIView else {
            return
        }
        if loadingView.superview != nil {
            loadingView.removeFromSuperview()
        }
        var showInView = UIApplication.shared.keyWindow ?? UIView()
        if let inView = inView {
            showInView = inView
        }
        let showInViewSize = showInView.frame.size
        loadingView.center = CGPoint(x: showInViewSize.width * 0.5, y: showInViewSize.height * 0.5)
        showInView.addSubview(loadingView)
    }
    
    func remove() {
        guard let loadingView = loadingView as? UIView else {
            return
        }
        if loadingView.superview != nil {
            stopLoading() {
                loadingView.removeFromSuperview()
            }
        }
    }
}
