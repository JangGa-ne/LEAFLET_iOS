//
//  HomeVC.swift
//  leaflet
//
//  Created by 제현 on 7/15/24.
//

import UIKit

class HomeCC: UICollectionViewCell {
    
    @IBOutlet weak var category_img: UIImageView!
    @IBOutlet weak var category_label: UILabel!
    
    @IBOutlet weak var storeMain_img: UIImageView!
    @IBOutlet weak var storeName_label: UILabel!
    @IBOutlet weak var storeCategory_label: UILabel!
}

class HomeTC: UITableViewCell {
    
    var delegate: HomeVC = HomeVC()
    var indexpath_section: Int = 0
    var indexpath_row: Int = 0
    
    @IBOutlet weak var mainTitle_label: UILabel!
    @IBOutlet weak var subTitle_label: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func viewDidLoad() {
        
        collectionView.delegate = nil; collectionView.dataSource = nil
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10; layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
        collectionView.delegate = self; collectionView.dataSource = self
    }
}

extension HomeTC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if indexpath_section == 0, category_name.count > 0 {
            return category_name.count
        } else if indexpath_section == 1, StoreArray.count > 0 {
            return StoreArray.count
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? HomeCC else { return }
        
        if indexpath_section == 1 {
            let data = StoreArray[indexPath.row]
            setKingfisher(imageView: cell.storeMain_img, imageUrl: data.img_store_main, cornerRadius: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? HomeCC else { return }
        
        if indexpath_section == 1 {
            cancelKingfisher(imageView: cell.storeMain_img)
            cell.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCC", for: indexPath) as! HomeCC
        if indexpath_section == 0 {
            if #available(iOS 13.0, *) {
                cell.backgroundColor = indexPath.row == 0 ? .systemBlue.withAlphaComponent(0.7) : .secondarySystemGroupedBackground
                cell.category_label.textColor = indexPath.row == 0 ? .white : .label
            } else {
                cell.backgroundColor = indexPath.row == 0 ? .systemBlue.withAlphaComponent(0.7) : .white
                cell.category_label.textColor = indexPath.row == 0 ? .white : .black
            }
            cell.category_img.image = UIImage(named: category_img[category_name[indexPath.row]] ?? "")
            cell.category_label.text = category_name[indexPath.row]
        } else if indexpath_section == 1 {
            let data = StoreArray[indexPath.row]
            cell.storeName_label.text = data.store_name
            cell.storeCategory_label.text = data.store_category
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexpath_section == 0 {
            indexpath_row = indexPath.row
        } else if indexpath_section == 1 {
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "StoreDetailVC") as! StoreDetailVC
            segue.StoreObject = StoreArray[indexPath.row]
            delegate.navigationController?.pushViewController(segue, animated: true)
        }; collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexpath_section == 0 {
            return CGSize(width: stringWidth(text: category_name[indexPath.row], fontSize: 14.4, fontWeight: .bold)+55, height: collectionView.frame.height)
        } else if indexpath_section == 1 {
            return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        } else {
            return .zero
        }
    }
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeVCdelegate = self
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = .zero }
        tableView.delegate = self; tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
        
        StoreDetailVCdelegate = nil
        
        for i in 0...1 {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: i)) as? HomeTC {
                cell.collectionView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    func putData() {
        
        let params: [String: Any] = [
            "store_category": "",
            "store_cash": 0,
            "store_color": "",
            "store_id": "",
            "store_pw": "",
            "store_tag": [],
            "store_name": "",
            "store_tel": "",
            "store_reg_num": "",
            "store_opening": "",
            "store_address": "",
            "store_lat": 0.0,
            "store_lng": 0.0,
            "owner_name": "",
            "img_store_main": "",
            "img_store_sub": [],
            "manager_name": "",
            "waiting_step": 0,
        ]
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTCT") as! HomeTC
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .zero : 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, category_name.count > 0 {
            return 1
        } else if section == 1, StoreArray.count > 0 {
            return 1
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? HomeTC else { return }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTC1", for: indexPath) as! HomeTC
            cell.delegate = self
            cell.indexpath_section = indexPath.section
            cell.viewDidLoad()
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTC2", for: indexPath) as! HomeTC
            cell.delegate = self
            cell.indexpath_section = indexPath.section
            cell.viewDidLoad()
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
