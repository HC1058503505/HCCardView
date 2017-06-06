# HCCardView

> 该项目主要练习了自定义瀑布流，代理，闭包的使用。

* 头部与内容的联动效果(标题文字,选中指示器的渐变)
```
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

* UICollectionView的自定义布局
* 表情键盘的联动效果使用了代理，闭包两种方式来实现
