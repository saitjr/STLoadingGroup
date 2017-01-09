//
//  ViewController.swift
//  STLoadingGroup
//
//  Created by saitjr on 9/13/16.
//  Copyright © 2016 saitjr. All rights reserved.
//

import UIKit

private struct Const {
    static let loadingCellIdentifier = "LoadingCell"
    
    static let tintColor: UIColor = UIColor(red: 33 / 255.0, green: 36 / 255.0, blue: 44 / 255.0, alpha: 1)
    static let minSpacing: CGFloat = 10
    static let margin: CGFloat = 10
    static let cellNumberInRow: Int = 3
    static let minScale: CGFloat = 0.4
    static let titleLabelHeight: CGFloat = 80
    
    static let animationDuration: TimeInterval = 0.7
}

class ViewController: UIViewController {
    
    fileprivate var dataSource: [LoadingModel] = []
    fileprivate var titleLabel: UILabel = UILabel()
    
    fileprivate var cellSize: CGSize {
        let side = (UIScreen.main.bounds.size.width - Const.minSpacing * CGFloat(Const.cellNumberInRow - 1) - 2 * Const.margin) / CGFloat(Const.cellNumberInRow)
        return CGSize(width: side, height: side)
    }
    
    fileprivate var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            animateRow((oldValue as NSIndexPath).row, toIndex: (selectedIndexPath as NSIndexPath).row)
        }
    }
    
    fileprivate lazy var selectedView: UIView = {
        $0.frame = CGRect(origin: .zero, size: self.cellSize)
        $0.backgroundColor = Const.tintColor
        return $0
    }(UIView())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNotification()
        setupData()
        setupUI()
        
        let launchScreenVC = LaunchScreenViewController()
        addChildViewController(launchScreenVC)
        view.addSubview(launchScreenVC.view)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    internal func enterForground() {
        for model in dataSource {
            model.loadingGroup?.startLoading()
        }
    }
    
    internal func enterBackground() {
        for model in dataSource {
            model.loadingGroup?.stopLoading()
        }
    }
}

extension ViewController {
    fileprivate func setupUI() {
        // self config
        view.backgroundColor = Const.tintColor.withAlphaComponent(0.5)
        
        // title label
        titleLabel.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.size.width, height: Const.titleLabelHeight))
        titleLabel.text = dataSource[0].title
        titleLabel.textColor = .white
        if #available(iOS 8.2, *) {
            titleLabel.font = .systemFont(ofSize: 22, weight: 0.5)
        } else {
            // Fallback on earlier versions
            titleLabel.font = .systemFont(ofSize: 22)
        }
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        selectedIndexPath = IndexPath(row: 0, section: 0)
        view.addSubview(selectedView)
        
        // collection view
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Const.minSpacing
        layout.minimumInteritemSpacing = Const.minSpacing
        
        let collectionView = UICollectionView(frame: CGRect(x: Const.margin, y: titleLabel.bounds.size.height + Const.margin, width: view.bounds.size.width - 2 * Const.margin, height: view.bounds.size.height - titleLabel.bounds.size.height - 2 * Const.margin), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: Const.loadingCellIdentifier)
    }
    
    fileprivate func setupData() {
        let styles: [STLoadingStyle] = [.submit, .glasses, .walk, .arch, .bouncyPreloader, .zhihu, .triangle]
        
        for i in 0..<styles.count {
            var side: CGFloat = 50
            let style = styles[i]
            
            if style == .arch {
                side = 80
            }
            
            let loadingGroup = STLoadingGroup(side: side, style: style)
            let loadingModel = LoadingModel(title: style.rawValue, color: .clear, loadingGroup: loadingGroup)
            dataSource.append(loadingModel)
        }
    }
    
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterForground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: .UIApplicationDidEnterBackground, object: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LoadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.loadingCellIdentifier, for: indexPath) as! LoadingCell
        cell.model = dataSource[indexPath.row]
        guard let loadingGroup = dataSource[indexPath.row].loadingGroup else {
            return cell
        }
        loadingGroup.show(cell)
        loadingGroup.startLoading()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

extension ViewController {
    fileprivate func animateRow(_ fromIndex: Int, toIndex: Int) {
        animateSelectView(fromIndex, toIndex: toIndex)
        
        let fromString = dataSource[fromIndex].title
        let toString = dataSource[toIndex].title
        animateTitle(fromString, toString: toString)
    }
    
    fileprivate func animateSelectView(_ fromIndex: Int, toIndex: Int) {
        let xIndex = CGFloat(toIndex % Const.cellNumberInRow)
        let yIndex = CGFloat(toIndex / Const.cellNumberInRow)
        
        let x = xIndex * Const.minSpacing + xIndex * cellSize.width + Const.margin
        let y = yIndex * Const.minSpacing + yIndex * cellSize.height + Const.margin + Const.titleLabelHeight
        
        UIView.animate(withDuration: Const.animationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: UIViewAnimationOptions(), animations: {
            self.selectedView.frame = CGRect(origin: CGPoint(x: x, y: y), size: self.cellSize)
        }, completion: { _ in
            
        })
    }
    
    fileprivate func animateTitle(_ fromString: String, toString: String) {
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.size.width, height: Const.titleLabelHeight))
        tempLabel.font = titleLabel.font
        tempLabel.textColor = titleLabel.textColor
        tempLabel.text = toString
        tempLabel.textAlignment = titleLabel.textAlignment
        tempLabel.transform = CGAffineTransform(scaleX: Const.minScale, y: Const.minScale)
        tempLabel.alpha = 0
        view.addSubview(tempLabel)
        
        UIView.animateKeyframes(withDuration: Const.animationDuration * 0.5, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: { 
                self.titleLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1, animations: { 
                self.titleLabel.alpha = 0
                tempLabel.transform = CGAffineTransform.identity
                self.titleLabel.transform = CGAffineTransform(scaleX: Const.minScale, y: Const.minScale)
                tempLabel.alpha = 1
            })
        }, completion: { _ in
            self.titleLabel.removeFromSuperview()
            self.titleLabel = tempLabel
        })
    }
}
