//
//  HCCardView.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/23.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit

class HCCardView: UIView {
    
    let titles:[String]
    let childVCs:[UIViewController]
    let parentVC:UIViewController
    let cardViewStyle:HCCardViewStyle
    
    
    /**!
     创建HCCardView实例对象
     - parameters:
        - frame: HCCardView实例的位置尺寸
        - titles: HCCardView的标题数组
        - childVCs: 子控制器数组
        - parentVC: 父控制器
        - cardViewStyle: HCCardView的风格设置
     */
    init(frame: CGRect, titles:[String], childVCs:[UIViewController], parentVC:UIViewController, cardViewStyle:HCCardViewStyle) {
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.cardViewStyle = cardViewStyle
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HCCardView {

    func setupUI(){
        // 添加头部标题
        let headerV = HCCardHeaderView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: cardViewStyle.headerViewHeight), titles: titles, headerViewStyle: cardViewStyle)
        addSubview(headerV)
        // 添加内容主题
        let contentV = HCCardContentView(frame: CGRect(x: 0, y: headerV.frame.maxY, width: bounds.width, height: bounds.height - 40), childVCs: childVCs, parentVC: parentVC, contentViewStyle: cardViewStyle)
        addSubview(contentV)
        // 设置代理，实现联动
        headerV.cardHeaderViewDelegate = contentV
        contentV.cardContentViewDelegate = headerV
    }
}
