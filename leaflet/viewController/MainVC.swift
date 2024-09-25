//
//  MainVC.swift
//  leaflet
//
//  Created by 제현 on 8/7/24.
//

import UIKit

class MainCC: UICollectionViewCell {
    
    @IBOutlet weak var category_img: UIImageView!
    @IBOutlet weak var categoryName_label: UILabel!
    
    @IBOutlet weak var storeMain_img: UIImageView!
    @IBOutlet weak var storeName_label: UILabel!
}

class MainTC: UITableViewCell {
    
    var delegate: MainVC = MainVC()
    var indexpath_section: Int = 0
    
    var StoreArray: [StoreData] = []
    
    @IBOutlet weak var sectionTitle_label: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func viewDidLoad() {
        
        collectionView.delegate = nil; collectionView.dataSource = nil
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
        collectionView.delegate = self; collectionView.dataSource = self
    }
}

extension MainTC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? MainCC else { return }
        
        if StoreArray.count > 0 {
            let data = StoreArray[indexPath.row]
            setKingfisher(imageView: cell.storeMain_img, imageUrl: data.img_store_main, cornerRadius: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? MainCC else { return }
        
        if StoreArray.count > 0 {
            cancelKingfisher(imageView: cell.storeMain_img)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if indexpath_section == 0, category_name.count > 0 {
            return category_name.count
        } else if StoreArray.count > 0 {
            return StoreArray.count
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCC", for: indexPath) as! MainCC
        
        if indexpath_section == 0 {
            cell.category_img.image = UIImage(named: category_img[category_name[indexPath.row]] ?? "")
            cell.categoryName_label.text = category_name[indexPath.row]
        } else {
            let data = StoreArray[indexPath.row]
            cell.storeName_label.text = data.store_name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexpath_section == 0 {
            return CGSize(width: collectionView.bounds.height-20, height: collectionView.bounds.height)
        } else if StoreArray.count > 0 {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        } else {
            return .zero
        }
    }
}

class MainVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return.darkContent } else { return .default }
    }
    
    let section_title: [String] = ["", "배고플땐 여기서 :D", "마음이 편한한 휴양지 🌳"]
    var RestaurantArray: [StoreData] = []
    var VillaArray: [StoreData] = []
    
    @IBOutlet weak var korea_gif: UIView!
    @IBOutlet weak var search_tf: UITextField!
    @IBOutlet weak var map: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainVCdelegate = self
        setKeyboard()
        
        setGifImage(view: korea_gif, imageName: "korea")
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = .zero }
        tableView.delegate = self; tableView.dataSource = self
        
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(map(_:))))
        
        ["맛집", "풀빌라펜션"].enumerated().forEach { i, category in
            dispatchGroup.enter()
            requestGetStore(limit: 10, category_name: category) { array, state in
                if i == 0 {
                    self.RestaurantArray = array
                    for _ in 0...9 {
                        self.RestaurantArray.append(array[0])
                    }
                } else if i == 1 {
                    self.VillaArray = array
                }; self.tableView.reloadData()
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.VillaArray = self.RestaurantArray; self.tableView.reloadData()
            print(self.VillaArray)
        }
    }
    
    @objc func map(_ sender: UITapGestureRecognizer) {
        segueViewController(identifier: "MapVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if section_title.count > 0 { return section_title.count } else { return .zero }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTCT") as! MainTC
        cell.sectionTitle_label.text = section_title[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section_title[section] == "") ? .zero : 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, category_name.count > 0 {
            return 1
        } else if section == 1, RestaurantArray.count > 0 {
            return 1
        } else if section == 2, VillaArray.count > 0 {
            return 1
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: (indexPath.section == 0) ? "MainTC1" : "MainTC2", for: indexPath) as! MainTC
        
        cell.delegate = self
        cell.indexpath_section = indexPath.section
        cell.StoreArray = (indexPath.section != 0) ? [RestaurantArray, VillaArray][indexPath.section-1] : []
        cell.viewDidLoad()
        
        return cell
    }
}
