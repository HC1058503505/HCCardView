//
//  HCEmojiCollectionViewFlowLayout.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/27.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit

/// 表情键盘布局
class HCEmojiCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var minimumColumns:Int = 3
    var minimumRows:Int = 3
    fileprivate var totalPage:Int = 0
    
    
    fileprivate var attributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
}

extension HCEmojiCollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let collectionV = collectionView!
        let sections = collectionV.numberOfSections
        let itemWidth = (collectionV.frame.width - sectionInset.left - sectionInset.right - CGFloat(minimumColumns + 1) * minimumLineSpacing) / CGFloat(minimumColumns)
        let itemHeight = (collectionV.frame.height - sectionInset.top - sectionInset.bottom - CGFloat(minimumRows + 1) * minimumInteritemSpacing) / CGFloat(minimumRows)
        
        
        for section in 0 ..< sections {
            let rows = collectionV.numberOfItems(inSection: section)
            
            for row in 0 ..< rows {
                let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: row, section: section))
                let page = row / (minimumRows * minimumColumns)
                // 九宫格
                let col = row % minimumColumns
                let r = (row - page * minimumColumns * minimumRows ) / minimumColumns
                let x = CGFloat(totalPage + page) * collectionV.frame.width + sectionInset.left + minimumInteritemSpacing + (itemWidth + minimumInteritemSpacing) * CGFloat(col)
                let y = sectionInset.top + minimumLineSpacing + (itemHeight + minimumLineSpacing) * CGFloat(r)
                
                attribute.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                attributes.append(attribute)
            }
            
            totalPage += rows / (minimumRows * minimumColumns) + 1
        }
        
    }
}

extension HCEmojiCollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

extension HCEmojiCollectionViewFlowLayout {
    override var collectionViewContentSize: CGSize {
        let attributeMaxWidth:CGFloat = CGFloat(totalPage) * collectionView!.frame.width
        return CGSize(width: attributeMaxWidth, height: collectionView!.frame.height)
    }
}
