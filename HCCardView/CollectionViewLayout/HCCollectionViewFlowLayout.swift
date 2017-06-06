//
//  HCCollectionViewFlowLayout.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/25.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit

protocol UICollectionViewFlowLayoutDataSource:class {
    func numberOfColumns(in collection:UICollectionView) -> Int
    func heightOfItems(in collection:UICollectionView, at indexPath:IndexPath) -> CGFloat
}

/// 自定义流水布局
class HCCollectionViewFlowLayout: UICollectionViewFlowLayout {
    weak var flowLayoutDataSource:UICollectionViewFlowLayoutDataSource?
    fileprivate lazy var attributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var layoutMaxY: CGFloat = {
        return self.sectionInset.top + self.sectionInset.bottom
    }()
    
    fileprivate lazy var columns: Int = {
        return self.flowLayoutDataSource?.numberOfColumns(in: self.collectionView!) ?? 3
    }()
    
    fileprivate lazy var itemH: [CGFloat] = {
        return Array(repeating: self.sectionInset.top + self.minimumLineSpacing, count: self.columns)
    }()
}

// MARK: - 准备布局
extension HCCollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let numberItems:Int = collectionView!.numberOfItems(inSection: 0)
        let itemWidth:CGFloat = (collectionView!.frame.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(columns + 1)) / CGFloat(columns)
        
        for i in attributes.count ..< numberItems {
            let indexP = IndexPath(item: i, section: 0)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexP)
            
            let randomH = flowLayoutDataSource?.heightOfItems(in: collectionView!, at: indexP) ?? 100
            
            let itemY = itemH.min()!
            let itemYIndex = itemH.index(of: itemY)!
            
            let itemX = sectionInset.left + minimumInteritemSpacing + (itemWidth + minimumInteritemSpacing) * CGFloat(itemYIndex)
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: randomH)
            
            attributes.append(attribute)
            itemH[itemYIndex] = attribute.frame.maxY + minimumLineSpacing
        }
        
        layoutMaxY = itemH.max()! + sectionInset.bottom
    }
}

// MARK: - 返回布局
extension HCCollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributes
    }
    
}
// MARK: - 布局作用范围
extension HCCollectionViewFlowLayout{
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: layoutMaxY)
    }
}
