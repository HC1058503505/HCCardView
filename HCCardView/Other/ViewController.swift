//
//  ViewController.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/23.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HCCardView"
        automaticallyAdjustsScrollViewInsets = false
        let titles:[String] = ["全部","视频","图片","段子","互动区","相册","网红","投票","美女"];
        
        let childVCs:[UIViewController] = { () -> [UIViewController] in
            var childM:[UIViewController] = [UIViewController]()
            let allVC = HCContentViewController(type: HCContentViewControllerType.All)
            let videoVC = HCContentViewController(type: HCContentViewControllerType.Video)
            let pictureVC = HCContentViewController(type: HCContentViewControllerType.Picture)
            let jokeVC = HCContentViewController(type: HCContentViewControllerType.Joke)
            let interactionVC = HCContentViewController(type: HCContentViewControllerType.Interaction)
            let ablumVC = HCContentViewController(type: HCContentViewControllerType.Album)
            let netpopularVC = HCContentViewController(type: HCContentViewControllerType.NetPopular)
            let voteVC = HCContentViewController(type: HCContentViewControllerType.Vote)
            let beautyVC = HCContentViewController(type: HCContentViewControllerType.Beauty)
            childM.append(contentsOf: [allVC,videoVC,pictureVC,jokeVC,interactionVC,ablumVC,netpopularVC,voteVC,beautyVC])
            return childM
        }()
        
        var cardViewStyle:HCCardViewStyle = HCCardViewStyle()
        cardViewStyle.headerViewBGColor = UIColor.orange    // 标题栏背景色
        cardViewStyle.headerViewHeight = 44;                // 标题栏高度
        cardViewStyle.itemNormalFontSize = 15;              // 标题文字Normal模式文字大小
        cardViewStyle.itemSelectedFontSize = 18;            // 标题文字Selected模式文字大小
        
        cardViewStyle.itemNormalColor = UIColor.white       // 标题文字Normal模式文字颜色
        cardViewStyle.itemSelectedColor = UIColor.red       // 标题文字Selected模式文字颜色
        cardViewStyle.isGradient = true                     // 标题文字切换时文字颜色是否渐变
//        cardViewStyle.isShowLineView = false              // 是否展示下滑view
        cardViewStyle.lineViewColor = UIColor.green         // 下滑view背景色
//        cardViewStyle.isShowCoverView = false             // 是否item背景view
        cardViewStyle.coverViewColor = UIColor.white        // item背景view背景色
        
        let cardV: HCCardView = HCCardView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64), titles: titles, childVCs: childVCs, parentVC: self, cardViewStyle: cardViewStyle)
        view.addSubview(cardV)
     
//        HCNetWorking.request("http://s.budejie.com/topic/list/zuixin/1/bs0315-iphone-4.5.6/0-20.json", method: .GET, success: { (result) in
//            do {
//                let resultDic = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String:Any]
//                print(resultDic["list"] ?? "nil")
//            } catch {
//            }
//            
//        }) { (error) in
//            print(error)
//        }
        
//        HCNetWorking.request("http://s.budejie.com/topic/list/zuixin/1/bs0315-iphone-4.5.6/0-20.json")
//        .responseJSON { (res) in
//            print(res)
//        }
//        .responseString { (res) in
//            print(res)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

