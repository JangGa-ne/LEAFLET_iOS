//
//  StoreDetailVC.swift
//  leaflet
//
//  Created by 제현 on 7/17/24.
//

import UIKit
import ImageSlideshow

class StoreDetailCC: UICollectionViewCell {
    
    @IBOutlet weak var menu_img: UIImageView!
    
    @IBOutlet weak var menuName_label: UILabel!
    @IBOutlet weak var menuPrice_label: UILabel!
}

class StoreDetailTC: UITableViewCell {
    
    var delegate: StoreDetailVC = StoreDetailVC()
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var menuName_label: UILabel!
    @IBOutlet weak var menuPrice_label: UILabel!
    @IBOutlet weak var memuContent_label: UILabel!
    @IBOutlet weak var menu_img: UIImageView!
    
    func viewDidLoad() {
        
        collectionView.delegate = nil; collectionView.dataSource = nil
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        collectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
        collectionView.delegate = self; collectionView.dataSource = self
    }
}

extension StoreDetailTC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if delegate.menu_top.count > 0 { return delegate.menu_top.count } else { return .zero }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? StoreDetailCC else { return }
        
        let data = delegate.menu_top[indexPath.row]
        setKingfisher(imageView: cell.menu_img, imageUrl: data.img_menu)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? StoreDetailCC else { return }
        
        cancelKingfisher(imageView: cell.menu_img)
        cell.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = delegate.menu_top[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreDetailCC", for: indexPath) as! StoreDetailCC
        
        cell.menu_img.layer.cornerRadius = 15
        cell.menu_img.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.menuName_label.text = data.name
        cell.menuPrice_label.text = numberFormat.string(from: data.price as NSNumber) ?? "0"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: collectionView.frame.height)
    }
}

class StoreDetailVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let section_name: [String] = ["대표메뉴", "전체메뉴"]
    var StoreObject: StoreData = StoreData()
    var MenuObject: MenuData = MenuData()
    var menu_top: [(top: Bool, id: String, name: String, price: Int, content: String, img_menu: String)] = []
    
    @IBOutlet weak var back_btn: UIButton!
    @IBAction func back_btn(_ sender: UIButton) { navigationController?.popViewController(animated: true)}
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storeSub_iss: ImageSlideshow!
    @IBOutlet weak var storeSub_iss_ratio: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var storeMain_img: UIImageView!
    
    @IBOutlet weak var storeName_label: UILabel!
    @IBOutlet weak var storeCategory_label: UILabel!
    
    @IBOutlet weak var scrap_btn: UIButton!
    @IBOutlet weak var call_btn: UIButton!
    @IBOutlet weak var info_btn: UIButton!
    
    @IBOutlet weak var countViews_label: UILabel!
    @IBOutlet weak var countReview_label: UILabel!
    @IBOutlet weak var countScrap_label: UILabel!
    
    @IBOutlet weak var storeEdit_btn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreDetailVCdelegate = self
        checkUserInterfaceStyle()
        
        setImageSlideShew(imageView: storeSub_iss, imageUrls: StoreObject.img_store_sub, completionHandler: nil)
        storeSub_iss_ratio.constant = UIApplication.shared.statusBarFrame.height
        roundedView.layer.cornerRadius = 15
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setKingfisher(imageView: storeMain_img, imageUrl: StoreObject.img_store_main, cornerRadius: 47)
        
        storeName_label.text = StoreObject.store_name
        storeCategory_label.text = StoreObject.store_category
        
        ([scrap_btn, call_btn, info_btn] as [UIButton]).enumerated().forEach { i, btn in
            btn.tag = i; btn.addTarget(self, action: #selector(top_btn(_:)), for: .touchUpInside)
        }
        
        countViews_label.text = numberFormat.string(from: StoreObject.count_views as NSNumber) ?? "0"
        countReview_label.text = numberFormat.string(from: StoreObject.count_review as NSNumber) ?? "0"
        countScrap_label.text = numberFormat.string(from: StoreObject.count_scrap as NSNumber) ?? "0"
        
        storeEdit_btn.addTarget(self, action: #selector(storeEdit_btn(_:)), for: .touchUpInside)
        
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        if #available(iOS 15, *) { tableView.sectionHeaderTopPadding = .zero }
        tableView.delegate = self; tableView.dataSource = self
        
        requestGetMenu(store_id: StoreObject.store_id) { object, state in
            self.MenuObject.menu = object.menu
            self.menu_top = object.menu.filter { $0.top == true }
            self.tableView.reloadData()
            self.tableView_height.constant = CGFloat(self.tableView.numberOfSections*30)+200+CGFloat(self.MenuObject.menu.count*100)
        }
    }
    
    @objc func top_btn(_ sender: UIButton) {
        switch sender.tag {
        case 0: break
        case 1: break
        case 2: segueViewController(identifier: "StoreInfoVC")
        default: break
        }
    }
    
    @objc func storeEdit_btn(_ sender: UIButton) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "StoreUploadVC") as! StoreUploadVC
        segue.StoreObject = StoreObject
        segue.MenuObject = MenuObject
        navigationController?.pushViewController(segue, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        StoreUploadVCdelegate = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        checkUserInterfaceStyle()
    }
}

extension StoreDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if section_name.count > 0 { return section_name.count } else { return .zero }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTCT") as! StoreDetailTC
        cell.title_label.text = section_name[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, menu_top.count > 0 {
            return 1
        } else if section == 1, MenuObject.menu.count > 0 {
            return MenuObject.menu.count
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? StoreDetailTC else { return }
        
        if indexPath.section == 1 {
            let data = MenuObject.menu[indexPath.row]
            setKingfisher(imageView: cell.menu_img, imageUrl: data.img_menu, cornerRadius: 10)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? StoreDetailTC else { return }
        
        if indexPath.section == 1 {
            cancelKingfisher(imageView: cell.menu_img)
            cell.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTC1", for: indexPath) as! StoreDetailTC
            cell.delegate = self
            cell.viewDidLoad()
            
            return cell
        } else if indexPath.section == 1 {
            
            let data = MenuObject.menu[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTC2", for: indexPath) as! StoreDetailTC
            cell.delegate = self
            
            cell.menuName_label.text = data.name
            cell.menuPrice_label.text = numberFormat.string(from: data.price as NSNumber) ?? "0"
            cell.memuContent_label.text = data.content
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
