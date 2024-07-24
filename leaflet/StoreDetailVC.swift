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
    
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var menuName_label: UILabel!
    @IBOutlet weak var menuPrice_label: UILabel!
    @IBOutlet weak var menuEtc_label: UILabel!
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreDetailCC", for: indexPath) as! StoreDetailCC
        
        cell.menu_img.layer.cornerRadius = 15
        cell.menu_img.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
    
    let menu_section: [String] = ["대표메뉴", "신메뉴"]
    
    @IBOutlet weak var back_btn: UIButton!
    @IBAction func back_btn(_ sender: UIButton) { navigationController?.popViewController(animated: true)}
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var store_iss: ImageSlideshow!
    @IBOutlet weak var store_iss_ratio: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var scrap_btn: UIButton!
    @IBOutlet weak var call_btn: UIButton!
    @IBOutlet weak var info_btn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreDetailVCdelegate = self
        checkUserInterfaceStyle()
        
        store_iss_ratio.constant = UIApplication.shared.statusBarFrame.height
        roundedView.layer.cornerRadius = 15
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        ([scrap_btn, call_btn, info_btn] as [UIButton]).enumerated().forEach { i, btn in
            btn.tag = i; btn.addTarget(self, action: #selector(top_btn(_:)), for: .touchUpInside)
        }
        
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        if #available(iOS 15, *) { tableView.sectionHeaderTopPadding = .zero }
        tableView.delegate = self; tableView.dataSource = self
        
        tableView_height.constant = CGFloat(tableView.numberOfSections*30)+200+CGFloat(10*100)
    }
    
    @objc func top_btn(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        checkUserInterfaceStyle()
    }
}

extension StoreDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if menu_section.count > 0 { return menu_section.count } else { return .zero }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTCT") as! StoreDetailTC
        cell.title_label.text = menu_section[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 10
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTC1", for: indexPath) as! StoreDetailTC
            cell.viewDidLoad()
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTC2", for: indexPath) as! StoreDetailTC
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
