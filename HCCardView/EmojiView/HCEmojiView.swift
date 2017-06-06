//
//  HCEmojiView.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/31.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit



class HCEmojiView: UIView {
    
    fileprivate let titles: [String]
    fileprivate let emojiViewStyle: HCCardViewStyle
    fileprivate var originOffsetX:CGFloat = 0
    fileprivate let sectionsNumber:[Int] = [13, 15, 17, 20]
    
    fileprivate lazy var headerView: HCCardHeaderView = {
        let headerV = HCCardHeaderView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.emojiViewStyle.headerViewHeight), titles: self.titles, headerViewStyle: self.emojiViewStyle)
        return headerV
    }()
    

    lazy var emojiContentView: HCEmojiViewContentView = {
        let emojiView = HCEmojiViewContentView(frame: CGRect(x: 0, y: self.emojiViewStyle.headerViewHeight, width: self.bounds.width, height: self.bounds.height - self.emojiViewStyle.headerViewHeight - 20), contentStyle: self.emojiViewStyle, titles: self.titles, sectionsNumber: self.sectionsNumber)
        return emojiView
    }()
    fileprivate lazy var pageControl: UIPageControl = {
        let pageCtr = UIPageControl(frame: CGRect(x: 0, y: self.emojiContentView.frame.maxY, width: self.bounds.width, height: 20))
        pageCtr.backgroundColor = UIColor.orange
        pageCtr.currentPageIndicatorTintColor = UIColor.white
        pageCtr.tintColor = UIColor.cyan
        pageCtr.numberOfPages = self.sectionsNumber[0] / (self.emojiViewStyle.emojiMinimumRows * self.emojiViewStyle.emojiMinimumColumns) + 1;
        return pageCtr
    }()
    
    init(frame: CGRect, titles: [String], emojiViewStyle: HCCardViewStyle) {
        self.titles = titles
        self.emojiViewStyle = emojiViewStyle
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension HCEmojiView {
    func setupUI(){
        
        addSubview(headerView)
        
        addSubview(emojiContentView)
        
        addSubview(pageControl)
        
        weak var weakSelf = self
        
        emojiContentView.emojiScroll = { section, numberOfRows, currentRow in
            weakSelf?.headerView.changeItem = {() -> Int in
                return section
            }
            
            weakSelf?.pageControl.numberOfPages = numberOfRows
            weakSelf?.pageControl.currentPage = currentRow
        }
        
        emojiContentView.emojiSelected = { numberOfPages,currentPage in
            weakSelf?.pageControl.numberOfPages = numberOfPages
            weakSelf?.pageControl.currentPage = 0
        
        }
//        emojiContentView.emojiViewDidScroll = self
//        emojiContentView.emojiViewDidSelected = self
        headerView.cardHeaderViewDelegate = emojiContentView
    }
}

//extension HCEmojiView: HCEmojiViewContentViewDelegate {
//    func emojiViewContentViewDidScroll(contentView: HCEmojiViewContentView, section: Int, numberOfRows: Int, currentRow: Int) {
//        headerView.changeItem = {() -> Int in
//            return section
//        }
//
//        pageControl.numberOfPages = numberOfRows
//        pageControl.currentPage = currentRow
//    }
//    
//    func emojiViewContentViewDidSelected(contentView: HCEmojiViewContentView, numberOfPages: Int, currentPage: Int) {
//        pageControl.numberOfPages = numberOfPages
//        pageControl.currentPage = 0
//    }
//}

