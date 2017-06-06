//
//  HCCardHeaderView.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/23.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Foundation
import UIKit

protocol HCCardHeaderViewDelegate:class {
    func cardHeaderView(headerView:HCCardHeaderView, currentIndex:Int)
}

typealias changeSelectedItem = () -> Int
class HCCardHeaderView: UIView {
    
    // weak只能修饰类
    // 所以 HCCardHeaderViewDelegate:class
    weak var cardHeaderViewDelegate: HCCardHeaderViewDelegate?
    // 闭包
    var changeItem: changeSelectedItem? {
        didSet {
            if let change = changeItem {
                let index = change()
                let targetBtn = buttons[index]
                selectedButtonAction(targetBtn: targetBtn)
                
                UIView.animate(withDuration: 0.2, animations: { 
                    
                    self.lineView.frame.size.width = targetBtn.frame.width + self.headerViewStyle.headerViewItemsMargin * 2.0
                    self.lineView.center.x = targetBtn.center.x
                    
                    self.coverView.frame.size.width = targetBtn.frame.width + self.headerViewStyle.headerViewItemsMargin * 2.0
                    self.coverView.center.x = targetBtn.center.x
                })
            }
        }
    }
    
    fileprivate let headerViewStyle:HCCardViewStyle
    fileprivate let titles:[String]
    fileprivate var currentBtn:UIButton?
    fileprivate var tapItem:Bool = false
    
    fileprivate lazy var beginColorRGB: (red:CGFloat, green:CGFloat, blue:CGFloat) = {
        var redBegin:CGFloat = 0.0
        var greenBegin:CGFloat = 0.0
        var blueBegin:CGFloat = 0.0
        var alphaBegin:CGFloat = 1.0
        self.headerViewStyle.itemSelectedColor.getRed(&redBegin, green: &greenBegin, blue: &blueBegin, alpha: &alphaBegin)
        return (redBegin, greenBegin,blueBegin)
    }()
    
    fileprivate lazy var toColorRGB: (red:CGFloat, green:CGFloat, blue:CGFloat) = {
        var redTo:CGFloat = 0.0
        var greenTo:CGFloat = 0.0
        var blueTo:CGFloat = 0.0
        var alphaTo:CGFloat = 1.0
        self.headerViewStyle.itemNormalColor.getRed(&redTo, green: &greenTo, blue: &blueTo, alpha: &alphaTo)
        return (redTo, greenTo, blueTo)
    }()

    
    fileprivate lazy var buttons: [UIButton] = {
        return [UIButton]()
    }()
    
    fileprivate lazy var scroll: UIScrollView = {
        let scrollV:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        scrollV.showsHorizontalScrollIndicator = false
        return scrollV
    }()
    
    fileprivate lazy var lineView: UIView = {
        let lineV = UIView()
        lineV.backgroundColor = self.headerViewStyle.lineViewColor
        return lineV
    }()
    
    lazy var coverView: UIView = {
        let coverV = UIView()
        coverV.isUserInteractionEnabled = true
        coverV.backgroundColor = self.headerViewStyle.coverViewColor
        return coverV
    }()
    
    init(frame: CGRect, titles:[String], headerViewStyle: HCCardViewStyle) {
        self.headerViewStyle = headerViewStyle
        self.titles = titles
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HCCardHeaderView {
    func setup() {
        backgroundColor = headerViewStyle.headerViewBGColor
        addSubview(scroll)
        
        
        
        for item in titles {
            
            let button:UIButton = createItem(itemTitle: item, parentView: scroll)
            
            if titles.index(of: item) == 0 {
                button.titleLabel?.font = UIFont.systemFont(ofSize: headerViewStyle.itemSelectedFontSize)
                button.setTitleColor(headerViewStyle.itemSelectedColor, for: .normal)
                button.isSelected = true
                currentBtn = button
            }
            scroll.addSubview(button)
            
            buttons.append(button)
        }
        
        scroll.contentSize = CGSize(width: (buttons.last?.frame.maxX)! + headerViewStyle.headerViewItemsMargin, height: bounds.height)
        
        if headerViewStyle.isShowLineView {
            
            lineView.frame.origin.y = buttons.first!.frame.maxY - 4
            lineView.frame.size.width = buttons.first!.frame.width + headerViewStyle.headerViewItemsMargin * 2
            lineView.frame.size.height = 2
            lineView.center.x = buttons.first!.center.x
            scroll.addSubview(lineView)
        }
        
        
        if headerViewStyle.isShowCoverView {
            coverView.frame.size.width = buttons.first!.frame.width + headerViewStyle.headerViewItemsMargin * 2
            coverView.frame.size.height = buttons.first!.frame.height - 15
            coverView.center = buttons.first!.center
            coverView.layer.cornerRadius = 10
            scroll.insertSubview(coverView, belowSubview: buttons.first!)
        }
    }
    
    // item点击事件
    func buttonAction(targetBtn:UIButton) {
        tapItem = true
        selectedButtonAction(targetBtn: targetBtn)
        
        cardHeaderViewDelegate?.cardHeaderView(headerView: self, currentIndex: buttons.index(of: targetBtn)!)
        tapItem = false
    }
    
}

extension HCCardHeaderView:HCCardContentViewDelegate {
    // 滚动下方的内容时选择对应的item
    func cardContentView(cardContentView: HCCardContentView, currentIndex: Int) {
        selectedButtonAction(targetBtn: buttons[currentIndex])
    }
    // 滚动下方的内容时返回begin -> to 按钮的索引已经进度
    func cardContentView(cardContentView: HCCardContentView, beginIndex: Int, toIndex: Int, progress: CGFloat) {
        
        // 如果点击了item不在执行下面的操作
        guard tapItem == false else {
            return
        }
        
        let beginBtn = buttons[beginIndex]
        let toBtn = buttons[toIndex]
        
        // 颜色渐变
        let redBegin:CGFloat = beginColorRGB.red
        let greenBegin:CGFloat = beginColorRGB.green
        let blueBegin:CGFloat = beginColorRGB.blue
        
        let redTo:CGFloat = toColorRGB.red
        let greenTo:CGFloat = toColorRGB.green
        let blueTo:CGFloat = toColorRGB.blue

        beginBtn.setTitleColor(UIColor(red:redBegin + (redTo - redBegin) * progress, green:greenBegin + (greenTo - greenBegin) * progress, blue: blueBegin + (blueTo - blueBegin) * progress, alpha: 1.0), for: .normal)
        
        toBtn.setTitleColor(UIColor(red: redTo + (redBegin - redTo) * progress, green:greenTo + (greenBegin - greenTo) * progress, blue: blueTo + (blueBegin - blueTo) * progress, alpha: 1.0), for: .normal)
        
    
        
        let gradientWidth:CGFloat = (toBtn.frame.width - beginBtn.frame.width) * progress + beginBtn.frame.width + headerViewStyle.headerViewItemsMargin * 2
        let gradientCenterX:CGFloat = (toBtn.center.x - beginBtn.center.x) * progress + beginBtn.center.x
        
        if headerViewStyle.isShowLineView {
            // lineView渐变
            lineView.frame.size.width = gradientWidth
            lineView.center.x = gradientCenterX
        }
        
        if headerViewStyle.isShowCoverView {
            
            // coverView渐变
            coverView.frame.size.width = gradientWidth
            coverView.center.x = gradientCenterX
        }
    }
}


extension HCCardHeaderView {
    
    func selectedButtonAction(targetBtn: UIButton) {
        
        guard targetBtn != currentBtn else {
            return
        }
        
        targetBtn.setTitleColor(headerViewStyle.itemSelectedColor, for: .normal)
        targetBtn.titleLabel?.font = UIFont.systemFont(ofSize: headerViewStyle.itemSelectedFontSize)
        targetBtn.isSelected = true
        
        
        currentBtn?.isSelected = false
        currentBtn?.titleLabel?.font = UIFont.systemFont(ofSize: headerViewStyle.itemNormalFontSize)
        currentBtn?.setTitleColor(headerViewStyle.itemNormalColor, for: .normal)
        
        var scrollOffsetX = targetBtn.center.x - bounds.width * 0.5
        let scrollOffsetMin:CGFloat = 0
        var scrollOffsetMax:CGFloat = scroll.contentSize.width - bounds.width
        
        if scrollOffsetMin > scrollOffsetMax {
           scrollOffsetMax = scrollOffsetMin
        }
        
        if scrollOffsetX < scrollOffsetMin {
            scrollOffsetX = scrollOffsetMin
        }
        
        if scrollOffsetX > scrollOffsetMax{
            scrollOffsetX = scrollOffsetMax
        }
        
        scroll.setContentOffset(CGPoint(x: scrollOffsetX, y: 0), animated: true)
        currentBtn = targetBtn
        
        if headerViewStyle.isShowCoverView && tapItem {
            UIView.animate(withDuration: 0.2, animations: { 
                self.coverView.frame.size.width = targetBtn.frame.width + self.headerViewStyle.headerViewItemsMargin * 2
                self.coverView.center.x = targetBtn.center.x
            })
        }
        
        // 用户设置isShowLineView = false
        // 用户滑动了contentView，由HCCardContentViewDelegate做渐变操作
        guard headerViewStyle.isShowLineView && tapItem else {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.lineView.frame.size.width = targetBtn.frame.width + self.headerViewStyle.headerViewItemsMargin * 2
            self.lineView.center.x = targetBtn.center.x
        })
        
    }
    
    func createItem(itemTitle:String, parentView: UIScrollView) -> UIButton {
        
        let buttonX = (parentView.subviews.last == nil) ? headerViewStyle.headerViewItemsMargin:parentView.subviews.last!.frame.maxX + headerViewStyle.headerViewItemsMargin
        
        let rect:CGRect = sizeWithText(text: itemTitle as NSString, font: UIFont.systemFont(ofSize: headerViewStyle.itemSelectedFontSize), size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        
        let buttonFrame:CGRect = CGRect(x: buttonX, y: 0, width: rect.size.width, height: bounds.height)
        
        let button:UIButton = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: headerViewStyle.itemNormalFontSize)
        button.frame = buttonFrame
        button.titleLabel?.textAlignment = .center
        button.setTitle(itemTitle, for: .normal)
        button.setTitleColor(headerViewStyle.itemNormalColor, for: .normal)
        button.addTarget(self, action: #selector(HCCardHeaderView.buttonAction(targetBtn:)), for: .touchUpInside)
        
        return button
    }
    
    /**
     * 计算字符串长度
     */
    func sizeWithText(text: NSString, font: UIFont, size: CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
}
