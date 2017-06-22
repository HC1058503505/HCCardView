//
//  HCLiveBroadcastViewController.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/27.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit
import IJKMediaFramework
import SnapKit
class HCLiveBroadcastViewController: UIViewController {
    var playerURLStr:String = ""
    private var playerVC:IJKFFMoviePlayerController!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.randomColor()
        automaticallyAdjustsScrollViewInsets = false

        addGroupPopGesture()
        
        addEmojiView()
        
        addPlayer()
        
        addPopBtn()
    }
    
    
    func addPlayer() {
        guard let playerURL = URL(string: playerURLStr) else {
            return
        }
        
        
        guard let player = IJKFFMoviePlayerController(contentURL: playerURL, with: IJKFFOptions.byDefault()) else {
            return
        }
        
        playerVC = player
        
        player.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 256)
        player.view.backgroundColor = UIColor.red
        player.view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue)
        player.scalingMode = .aspectFill
        view.autoresizesSubviews = true
        view.addSubview(player.view)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !playerVC.isPlaying() {
            playerVC.prepareToPlay()
        }
    }
    
    func btnAction() {
        navigationController?.popViewController(animated: true)
    }

    
    deinit {
        if playerVC != nil {
            playerVC.pause()
            playerVC.stop()
            playerVC.shutdown()
        }
    }
    
}


extension HCLiveBroadcastViewController {

    func addGroupPopGesture() {
        let gesture = navigationController?.interactivePopGestureRecognizer
        //        print("gesture的类名:\(NSStringFromClass((gesture?.classForCoder)!))")
        //        print("gesture的父类名:\(NSStringFromClass((gesture?.superclass)!))")
        
        var ivarCount:UInt32 = 0
        let ivarList = class_copyIvarList(gesture?.classForCoder, &ivarCount)
        for i in 0 ..< ivarCount {
            let ivar = ivarList![Int(i)]
            _ = ivar_getName(ivar)
            //            print("class_copyIvarList---\(String(cString: name!, encoding: .utf8) ?? "")")
        }
        
        free(ivarList)
        
        
        var proprtyCount:UInt32 = 0
        let propertyList = class_copyPropertyList(gesture?.classForCoder, &proprtyCount)
        for i in 0 ..< proprtyCount {
            _ = propertyList![Int(i)]
            //            print("class_copyPropertyList---\(String(cString: property_getName(property), encoding: .utf8) ?? "")")
        }
        free(propertyList)
        
        
        var ivarGesture:UInt32 = 0
        let ivarGestureList = class_copyIvarList(UIGestureRecognizer.self, &ivarGesture)
        for i in 0 ..< ivarGesture {
            let ivar = ivarGestureList![Int(i)]
            _ = ivar_getName(ivar)
            _ = ivar_getTypeEncoding(ivar)
            //            print("ivarGestureName---\(String(cString: name!, encoding: .utf8) ?? "")   ivarGestureType:\(String(cString: type!, encoding: .utf8) ?? "")")
        }
        
        free(ivarGestureList)
        
        
        
        // 全屏pop手势
        let targets = navigationController?.interactivePopGestureRecognizer?.value(forKeyPath: "_targets") as! Array<Any>
        
        let obj = targets.last! // (action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fe95d514850>)
        let selector = Selector(("handleNavigationTransition:"))
        let target = (obj as AnyObject).value(forKeyPath: "target") // navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: selector)
        
        view.addGestureRecognizer(pan)
    }
    
    func addEmojiView()  {
        // 添加表情键盘
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
        cardViewStyle.emojiMinimumRows = 4
        let emojiView = HCEmojiView(frame: CGRect(x: 0, y: view.bounds.height - 256, width: view.bounds.width, height: 256), titles: ["普通","会员专用","黄金会员专用","特级会员专用"], emojiViewStyle: cardViewStyle)
        view.addSubview(emojiView)
        
    }

    
    func addPopBtn() {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.setImage(UIImage(named: "icon_cross_close"), for: .normal)
        btn.addTarget(self, action: #selector(HCLiveBroadcastViewController.btnAction), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.width.height.equalTo(45)
        }
    }

}
