//
//  HCCardViewStyle.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/23.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Foundation
import UIKit



/** 
 设置HCCardView的风格样式

 * headerViewBGColor: 头部标题view背景颜色
 * headerViewHeight: 头部标题view的高度
 * headerViewItemsWidth: 标题的宽度
 * headerViewItemsMargin: 标题间的间距
 * itemNormalFontSize: 正常标题文字大小
 * itemSelectedFontSize: 选中标题文字大小
 
 * isGradient: 标题切换时文字大小，颜色，背景大小是否进行渐变
 * itemSelectedColor: 选中标题的文字颜色
 * itemNormalColor: 正常标题的文字颜色
 
 * isShowLineView: 是否显示选择指示器
 * lineViewColor: 选择指示器颜色
 
 * isShowCoverView: 是否显示标题背景指示器
 * coverViewColor: 标题背景指示器颜色
 
 * emojiMinimumRows: 表情键盘最小行数
 * emojiMinimumColumns: 表情键盘对消列数
 */
struct HCCardViewStyle {
    /// 头部标题view背景颜色
    var headerViewBGColor:UIColor = UIColor.white
    /// 头部标题view的高度
    var headerViewHeight:CGFloat = 64.0
    /// 标题的宽度
    var headerViewItemsWidth:CGFloat = 45.0
    /// 标题间的间距
    var headerViewItemsMargin:CGFloat = 15.0
    /// 正常标题文字大小
    var itemNormalFontSize:CGFloat = 13.0
    /// 选中标题文字大小
    var itemSelectedFontSize:CGFloat = 16.0
    
    /// 标题切换时文字大小，颜色，背景大小是否进行渐变
    var isGradient:Bool = false
    /// 选中标题的文字颜色
    var itemSelectedColor:UIColor = UIColor.red
    /// 正常标题的文字颜色
    var itemNormalColor:UIColor = UIColor.white
    
    /// 是否显示选择指示器
    var isShowLineView:Bool = true
    /// 选择指示器颜色
    var lineViewColor:UIColor = UIColor.white
    
    /// 是否显示标题背景指示器
    var isShowCoverView:Bool = true
    /// 标题背景指示器颜色
    var coverViewColor:UIColor = UIColor(white: 0.5, alpha: 0.3)
    
    /// 表情键盘最小行数
    var emojiMinimumRows: Int = 3
    /// 表情键盘对消列数
    var emojiMinimumColumns: Int = 3
}
