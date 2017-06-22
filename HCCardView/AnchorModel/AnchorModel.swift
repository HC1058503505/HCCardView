//
//  AnchorModel.swift
//  HCCardView
//
//  Created by UltraPower on 2017/6/20.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Foundation

struct AnchorCreator {
    var id:Int = 0
    var level:Int = 0
    var gender:Int = 0
    var nick:String = ""
    var portrait:String = ""
    
    static func anchorCreator(creator:[String : Any]) -> AnchorCreator {
        return AnchorCreator(id: creator["id"] as! Int, level: creator["level"] as! Int, gender: creator["gender"] as! Int, nick: creator["nick"] as! String, portrait: creator["portrait"] as! String)
    }
}

struct AnchorLabelDesc {
    var tab_name:String = ""
    var tab_key:String = ""
    var cl:[Int] = [Int]()
    
   static func anchorLabelDesc(labels:[[String : Any]]) -> [AnchorLabelDesc] {
        var lableDescs = [AnchorLabelDesc]()
        for label in labels {
           let labelDesc = AnchorLabelDesc(tab_name: label["tab_name"] as! String, tab_key: label["tab_key"] as! String, cl: label["cl"] as! [Int])
            lableDescs.append(labelDesc)
        }
        
        return lableDescs
    }
}


struct AnchorExtra {
    var cover:Any?
    var label:[AnchorLabelDesc] = [AnchorLabelDesc]()
    
    static func anchorExtra(extra:[String : Any]) -> AnchorExtra {
        return AnchorExtra(cover: extra["cover"], label: AnchorLabelDesc.anchorLabelDesc(labels: extra["label"] as! [[String:Any]]))
    }
}

struct AnchorLike {
    var icon:String = ""
    var id:Int = 0
    
    static func anchorLike(likes:[[String:Any]]) -> [AnchorLike] {
        var anchorLikes = [AnchorLike]()
        for like in likes {
            let anchorLike = AnchorLike(icon: like["icon"] as! String, id: like["id"] as! Int)
            anchorLikes.append(anchorLike)
        }
        return anchorLikes
    }
    
}

struct AnchorModel {
    var creator:AnchorCreator = AnchorCreator()
    var id:String = ""
    var name:String = ""
    var city:String = ""
    var share_addr:String = ""
    var stream_addr:String = ""
    var version:Int = 0
    var slot:Int = 0
    var live_type:String = ""
    var landscape:Int = 0
    var like:[AnchorLike] = [AnchorLike]()
    var optimal:Int = 0
    var online_users:Int = 0
    var group:Int = 0
    var link:Int = 0
    var multi:Int = 0
    var rotate:Int = 0
    var extra = AnchorExtra()
    
    static func anchorModel(lives:[[String:Any]]) -> [AnchorModel] {
        var anchorModelLives = [AnchorModel]()
        for live in lives {
            let creatorDic = live["creator"] as! [String:Any]
            let creatorStruct = AnchorCreator.anchorCreator(creator: creatorDic)
        
            let anchorLikes = AnchorLike.anchorLike(likes: live["like"] as! [[String : Any]])
            
            let extra = AnchorExtra.anchorExtra(extra: live["extra"] as! [String:Any])
            
            
            let anchorModel = AnchorModel(creator: creatorStruct, id: live["id"] as! String, name: live["name"] as! String, city: live["city"] as! String, share_addr: live["share_addr"] as! String, stream_addr: live["stream_addr"] as! String, version: live["version"] as! Int, slot: live["slot"] as! Int, live_type: live["live_type"] as! String, landscape: live["landscape"] as! Int, like: anchorLikes, optimal: live["optimal"] as! Int, online_users: live["online_users"] as! Int, group: live["group"] as! Int, link: live["link"] as! Int, multi: live["multi"] as! Int, rotate: live["rotate"] as! Int, extra: extra)
            anchorModelLives.append(anchorModel)
        }
        
        return anchorModelLives
    }
}
