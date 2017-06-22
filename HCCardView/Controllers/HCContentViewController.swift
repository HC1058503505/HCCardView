//
//  HCAllViewController.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/24.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import UIKit

enum HCContentViewControllerType {
    case All
    case Video
    case Picture
    case Joke
    case Interaction
    case Album
    case NetPopular
    case Vote
    case Beauty
}

class HCContentViewController: UIViewController {
    var controllerType:HCContentViewControllerType = .All
    var itemsCount = 30
    var collectionV:UICollectionView?
    var anchorList:[AnchorModel] = [AnchorModel]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(type: HCContentViewControllerType = .All) {
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        let layout = HCCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.flowLayoutDataSource = self
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    
        let collectionV = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        // 设置左边距时，自定义布局正常产生UICollectionViewLayoutAttributes,但是不调用DataSource返回cell 问题搁置
        collectionV.contentInset = UIEdgeInsetsMake(0, 0, 108, 0)
        
        collectionV.backgroundColor = UIColor.white
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.register(HCCollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCellId")
        view.addSubview(collectionV)
        self.collectionV = collectionV
        
        
        HCNetWorking.request("http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1", method: .GET).responseJSON { (result) in
            guard let lives = result as? [String : Any] else {
                return
            }
            guard let livesDicts = lives["lives"] else {
                return
            }
            let anchorList = AnchorModel.anchorModel(lives: livesDicts as! [[String:Any]])
            self.anchorList = anchorList
            DispatchQueue.main.async {
                collectionV.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HCContentViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellId", for: indexPath) as! HCCollectionViewCell
        cell.backgroundColor = UIColor.randomColor()
        // 如果在这里修改itemsCount的值，刷新collectionView，达到一定的数据时collectionView将不能重用cell
        // 因此会出现空白情况
        if anchorList.count > 0 && anchorList.count > indexPath.row{
            cell.anchorModel = anchorList[indexPath.row]
        }
        return cell
    }
}

extension HCContentViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let anchorM = anchorList[indexPath.row]
        let liveBroadcast = HCLiveBroadcastViewController()
        liveBroadcast.playerURLStr = anchorM.stream_addr
        navigationController?.pushViewController(liveBroadcast, animated: true)
    }
    
    // 底部刷新添加数据
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y + self.collectionV!.frame.height - 108 > self.collectionV!.contentSize.height {
            itemsCount += 20
            collectionV!.reloadData()
        }
    }
}


extension HCContentViewController:UICollectionViewFlowLayoutDataSource {
    func numberOfColumns(in collection: UICollectionView) -> Int {
        return 2
    }

    func heightOfItems(in collection: UICollectionView, at indexPath: IndexPath) -> CGFloat {
//        return indexPath.row % 2 == 0 ? view.bounds.height * 0.35 : view.bounds.height * 0.30
        return view.bounds.height * 0.3
    }
}
