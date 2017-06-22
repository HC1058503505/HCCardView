//
//  HCCollectionViewCell.swift
//  HCCardView
//
//  Created by UltraPower on 2017/6/20.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class HCCollectionViewCell: UICollectionViewCell {
    
    var anchorModel:AnchorModel = AnchorModel(){
        didSet {
            // 主播图像
            imageView.kf.setImage(with: URL(string: anchorModel.creator.portrait))
            // 观看人数
            watchNumber.text = "\(anchorModel.online_users)"
            // 主播昵称
            nickName.text = anchorModel.creator.nick
            let contentSize:CGSize = CGSize(width: CGFloat(MAXFLOAT), height: 15.0)
            let lengthNickName = anchorModel.creator.nick.sizeWith(contentSize: contentSize, font: UIFont.systemFont(ofSize: 12)).width
            var nickNameLength = lengthNickName + 20
            if nickNameLength > frame.width - 20 {
                nickNameLength = frame.width - 20
            }
            nickName.snp.updateConstraints { (make) in
                make.width.equalTo(imageView.snp.width).offset(nickNameLength - imageView.frame.width)
            }
            
            // 直播标题
            liveTitle.text = anchorModel.name.lengthOfBytes(using: .utf8) == 0 ? "欢迎来看我的直播"  :  anchorModel.name
            // 地点
            location.text = anchorModel.city.lengthOfBytes(using: .utf8) == 0 ? "在哪呢" : anchorModel.city
            // 等级
            levelabel.text = "\(anchorModel.creator.level)L"
        }
    }
    // 主播图片
    private lazy var imageView: UIImageView = {
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
        return imageV
    }()
    
    lazy var nickName: UILabel = {
        let nickL = UILabel()
        nickL.textColor = UIColor.white
        nickL.font = UIFont.systemFont(ofSize: 12)
        nickL.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        nickL.textAlignment = .center
        nickL.layer.cornerRadius = 7.5
        nickL.layer.masksToBounds = true
        nickL.text = "***"
        return nickL
    }()
    
    
    // 直播房间消息
    private lazy var infoView: UIView = {
        let infoV = UIView()
        infoV.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return infoV
    }()
    
    // 直播名称(标题)
    lazy var liveTitle: UILabel = {
        let liveL = UILabel()
        liveL.font = UIFont.systemFont(ofSize: 13)
        liveL.textColor = UIColor.white
        return liveL
    }()
    
    lazy var location: UILabel = {
        let locationL = UILabel()
        locationL.font = UIFont.systemFont(ofSize: 13)
        locationL.textColor = UIColor.white
        return locationL
    }()
    
    lazy var levelabel: UILabel = {
        let level = UILabel()
        level.textColor = UIColor.orange
        level.textAlignment = .right
        return level
    }()
    
    // 观看人数渐变背景
    private lazy var gradientView: UIView = {
        let gradientV = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kGradientViewWidth, height: kGradientViewHeight)
        gradientLayer.position = CGPoint(x: kGradientViewWidth * 0.5, y: kGradientViewHeight * 0.5)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientV.layer.insertSublayer(gradientLayer, at: 0)

        return gradientV
    }()
    
    // 观看人数
    private lazy var watchNumber: UILabel = {
        let watchLabel = UILabel()
        watchLabel.textAlignment = .right
        watchLabel.textColor = UIColor.white
        watchLabel.text = "000"
        return watchLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup() {
    
        contentView.addSubview(imageView)
        
        imageView.addSubview(nickName)
        nickName.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.left).offset(5)
            make.bottom.equalTo(imageView.snp.bottom).offset(-5)
            make.width.equalTo(imageView.snp.width).offset(-10)
            make.height.equalTo(15)
        }
        
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.left)
            make.top.equalTo(imageView.snp.bottom)
            make.right.equalTo(imageView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        infoView.addSubview(liveTitle)
        liveTitle.snp.makeConstraints { (make) in
            make.left.equalTo(infoView.snp.left).offset(5)
            make.right.equalTo(infoView.snp.right).offset(-5)
            make.top.equalTo(infoView.snp.top).offset(2.5)
            make.height.equalTo(15)
        }
        
        
        infoView.addSubview(location)
        location.snp.makeConstraints { (make) in
            make.left.equalTo(liveTitle.snp.left)
            make.bottom.equalTo(infoView.snp.bottom).offset(-2.5)
            make.height.equalTo(15)
        }
        
        infoView.addSubview(levelabel)
        levelabel.snp.makeConstraints { (make) in
            make.top.equalTo(location.snp.top)
            make.left.equalTo(location.snp.right).offset(5)
            make.right.equalTo(liveTitle.snp.right)
            make.width.equalTo(location.snp.width)
            make.height.equalTo(location.snp.height)
        }
        
        
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(kGradientViewWidth)
            make.height.equalTo(kGradientViewHeight)
        }

        gradientView.addSubview(watchNumber)
        watchNumber.snp.makeConstraints { (make) in
            make.right.equalTo(gradientView.snp.right)
            make.top.equalTo(gradientView.snp.top)
            make.width.equalTo(gradientView.snp.width)
            make.height.equalTo(gradientView.snp.height)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func sizeWith(contentSize:CGSize, font: UIFont) -> CGSize {
        let str = self as NSString
        do {
            let rect = try str.boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil)
            return rect.size
            
        } catch {
            
        }
        
        
    }
}
