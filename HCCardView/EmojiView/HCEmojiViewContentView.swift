//
//  HCEmojiViewContentView.swift
//  HCCardView
//
//  Created by UltraPower on 2017/6/5.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit

protocol HCEmojiViewContentViewDelegate: class {
    func emojiViewContentViewDidScroll(contentView: HCEmojiViewContentView, section: Int, numberOfRows: Int, currentRow:Int)
}


typealias emojiViewDidScroll = (_ section: Int, _ numberOfRows: Int, _ currentRow:Int) -> Void

class HCEmojiViewContentView: UIView {
    
    
    weak var emojiViewDidScroll: HCEmojiViewContentViewDelegate?
    weak var emojiViewDidSelected: HCEmojiViewContentViewDelegate?
    
    var emojiScroll:emojiViewDidScroll?
    
    
    fileprivate var contentStyle: HCCardViewStyle
    fileprivate var titles: [String]
    fileprivate var sectionsNumber: [Int]
    
    fileprivate lazy var pageComponent: [[Int]] = {
        let sections = self.collectionView.numberOfSections
        
        var component: [[Int]] = [[Int]]()
        var totalPage:Int = 1
        for sec in 0 ..< sections {
            let rows = self.collectionView.numberOfItems(inSection: sec)
            let page = rows / (self.contentStyle.emojiMinimumRows * self.contentStyle.emojiMinimumColumns) + 1
            var sectionPages:[Int] = [Int]()
            for i in 0 ..< page {
                sectionPages.append(totalPage)
                totalPage += 1
            }
            component.append(sectionPages)
        }
        return component
    }()
    
    
    fileprivate lazy var emojiFlowLayout: HCEmojiCollectionViewFlowLayout = {
        let flowLayout = HCEmojiCollectionViewFlowLayout()
        
        flowLayout.minimumRows = self.contentStyle.emojiMinimumRows
        flowLayout.minimumColumns = self.contentStyle.emojiMinimumColumns
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    fileprivate lazy var collectionView:UICollectionView = {
        
        let collectionV = UICollectionView(frame: self.bounds, collectionViewLayout: self.emojiFlowLayout)
        collectionV.isPagingEnabled = true
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCollectionViewID")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.bounces = false
        return collectionV
    }()
    
    
    init(frame: CGRect, contentStyle:HCCardViewStyle, titles:[String], sectionsNumber:[Int]) {
        self.contentStyle = contentStyle
        self.titles = titles
        self.sectionsNumber = sectionsNumber
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HCEmojiViewContentView {
    func setupUI(){
        addSubview(collectionView)
    }
}

extension HCEmojiViewContentView:UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionsNumber[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewID", for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageNum = Int(scrollView.contentOffset.x / collectionView.frame.width) + 1
        var section:Int = 0
        
        for sectionPage in pageComponent {
            
            guard sectionPage.contains(pageNum) else {
                section += 1
                continue
            }
            
            
            let sectionPagesNum = collectionView.numberOfItems(inSection: section) / (contentStyle.emojiMinimumRows * contentStyle.emojiMinimumColumns) + 1
            
            emojiScroll?(section,sectionPagesNum, sectionPage.index(of: pageNum)!)
            
            emojiViewDidScroll?.emojiViewContentViewDidScroll(contentView: self, section: section, numberOfRows: sectionPagesNum, currentRow: sectionPage.index(of: pageNum)!)
            break
            
        }
        
        
    }
    
}


extension HCEmojiViewContentView: HCCardHeaderViewDelegate {
    
    func totalPage(section: Int) -> Int {
        var pages:Int = 0
        for sec in 0 ..< section {
            let rows = collectionView.numberOfItems(inSection: sec)
            pages += rows / (emojiFlowLayout.minimumRows * emojiFlowLayout.minimumColumns) + 1
        }
        return pages
    }
    
    func cardHeaderView(headerView: HCCardHeaderView, currentIndex: Int) {
        collectionView.setContentOffset(CGPoint(x: CGFloat(totalPage(section: currentIndex)) * collectionView.frame.width, y: 0), animated: false)
    }
}


