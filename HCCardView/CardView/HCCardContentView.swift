//
//  HCCardContentView.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/23.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Foundation
import UIKit

protocol HCCardContentViewDelegate:class {
    // 当前CollectionView的索引，以实现与headerView的联动
    func cardContentView(cardContentView:HCCardContentView, currentIndex: Int)
    // 滑动时的起始位置以及进度，以实现渐变效果
    func cardContentView(cardContentView:HCCardContentView, beginIndex:Int, toIndex:Int, progress:CGFloat)
}

class HCCardContentView: UIView {
    
    weak var cardContentViewDelegate:HCCardContentViewDelegate?
    fileprivate var originOffsetX:CGFloat = 0
    fileprivate let childVCs:[UIViewController]
    fileprivate let parentVC:UIViewController
    fileprivate let contentViewStyle: HCCardViewStyle
    
    fileprivate lazy var contentCollectionV:UICollectionView = {
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        let collectionV:UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.white
        collectionV.isPagingEnabled = true
        collectionV.bounces = false
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Test")
        return collectionV
    }()
    
    init(frame: CGRect, childVCs:[UIViewController], parentVC:UIViewController, contentViewStyle: HCCardViewStyle) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.contentViewStyle = contentViewStyle
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension HCCardContentView {
    func setup() {
        
        addSubview(contentCollectionV)
        
        for item in childVCs {
            parentVC.addChildViewController(item)
        }
    }
}

extension HCCardContentView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cardContentViewDelegate != nil && collectionView.visibleCells.count > 0{
            cardContentViewDelegate?.cardContentView(cardContentView: self, currentIndex: (collectionView.indexPath(for: collectionView.visibleCells.last!)?.item)!)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        originOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollOffsetX = scrollView.contentOffset.x
        let scrollWidth = scrollView.frame.width
        var beginIndex:Int = 0
        var toIndex:Int = 0
        var progress:CGFloat = 0
        
        guard scrollOffsetX != originOffsetX && contentViewStyle.isGradient else {
            return
        }
        
        if scrollOffsetX > originOffsetX { // 左滑
            beginIndex = Int(originOffsetX / scrollWidth)
            toIndex = beginIndex + 1
            progress = (scrollOffsetX - originOffsetX) / scrollWidth
        } else { // 右滑
            beginIndex = Int(originOffsetX / scrollWidth)
            toIndex = beginIndex - 1
            progress = (originOffsetX - scrollOffsetX) / scrollWidth
        }
        
        cardContentViewDelegate?.cardContentView(cardContentView: self, beginIndex: beginIndex, toIndex: toIndex, progress: progress)
    }
}

extension HCCardContentView:UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Test", for: indexPath)
        cell.subviews.forEach({$0.removeFromSuperview()})
        cell.addSubview(childVCs[indexPath.item].view)
        return cell
    }

}

extension HCCardContentView:HCCardHeaderViewDelegate {
    func cardHeaderView(headerView: HCCardHeaderView, currentIndex: Int) {
        contentCollectionV.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
}
