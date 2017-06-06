# HCCardView

> 该项目主要练习了自定义瀑布流，代理，闭包的使用。

* 头部与内容的联动效果(标题文字,选中指示器的渐变)
```swift
// HCCardHeaderView.swift
// 1.点击头部标题，对应的内容部分联动
// 1.1定义代理 
protocol HCCardHeaderViewDelegate:class {
    // currentIndex 表示点击标题的索引
    func cardHeaderView(headerView:HCCardHeaderView, currentIndex:Int)
}


// item点击事件
// tapItem 标识是否是点击事件触发，区别于内容滚动时头部部分联动操作
func buttonAction(targetBtn:UIButton) {
    tapItem = true
    selectedButtonAction(targetBtn: targetBtn)
    
    cardHeaderViewDelegate?.cardHeaderView(headerView: self, currentIndex: buttons.index(of: targetBtn)!)
    tapItem = false
}

// HCCardContentView.swift
// 1.2代理实现
extension HCCardContentView:HCCardHeaderViewDelegate {
    func cardHeaderView(headerView: HCCardHeaderView, currentIndex: Int) {
        contentCollectionV.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
}
```

```swift
// HCCardContentView.swift
// 1.滑动内容部分，头部标题联动,以及渐变效果的实现
// 1.1定义代理
protocol HCCardContentViewDelegate:class {
    // 当前CollectionView的索引，以实现与headerView的联动
    func cardContentView(cardContentView:HCCardContentView, currentIndex: Int)
    // 滑动时的起始位置以及进度，以实现渐变效果
    func cardContentView(cardContentView:HCCardContentView, beginIndex:Int, toIndex:Int, progress:CGFloat)
}

extension HCCardContentView:UICollectionViewDelegate {    
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
        
        // 计算起始位置，进度
        if scrollOffsetX > originOffsetX { // 左滑
            beginIndex = Int(scrollOffsetX / scrollWidth)
            toIndex = beginIndex == childVCs.count - 1 ? beginIndex : beginIndex + 1
            progress = (scrollOffsetX - CGFloat(beginIndex) * scrollWidth) / scrollWidth
        } else { // 右滑
            toIndex = Int(scrollOffsetX / scrollWidth)
            beginIndex = toIndex + 1
            progress = (CGFloat(beginIndex) * scrollWidth - scrollOffsetX) / scrollWidth
        }
        
        
        // 通知代理，达到联动效果
        cardContentViewDelegate?.cardContentView(cardContentView: self, beginIndex: beginIndex, toIndex: toIndex, progress: progress)
    }
}


// 1.2代理实现
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

```
* UICollectionView的自定义布局
 > 自定义布局的实现步骤
 1.// MARK: - 准备布局
 2.// MARK: - 返回布局
 3.// MARK: - 布局作用范围
* 表情键盘的联动效果使用了代理，闭包两种方式来实现
