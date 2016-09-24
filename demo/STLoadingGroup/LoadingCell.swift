//
//  LoadingCell.swift
//  STLoadingGroup
//
//  Created by saitjr on 9/13/16.
//  Copyright © 2016 saitjr. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    
    fileprivate let loadingView: UIView
    
    var model: LoadingModel {
        didSet {
            backgroundColor = model.color
        }
    }
    
    override init(frame: CGRect) {
        loadingView = UIView()
        model = LoadingModel()
        
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
