//
//  MarketListVC.swift
//  leaflet
//
//  Created by 제현 on 8/8/24.
//

import UIKit
import ImageSlideshow

class MarketListTC: UITableViewCell {
    
    @IBOutlet weak var storeMain_img: UIImageView!
    @IBOutlet weak var storeName_label: UILabel!
    @IBOutlet weak var storeRating_label: UILabel!
    @IBOutlet weak var storeDistance_label: UILabel!
}

class MarketListVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var StoreArray: [StoreData] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ad_isv: ImageSlideshow!
    @IBOutlet weak var ad_isv_ratio: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageSlideShew(imageView: ad_isv, imageNames: ["background1"], completionHandler: nil)
        ad_isv_ratio.constant = UIApplication.shared.statusBarFrame.height
        
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.delegate = self; tableView.dataSource = self
        tableView_height.constant = CGFloat(StoreArray.count*110)
        
        requestMarketList { array, status in
            self.StoreArray = array
            self.tableView.reloadData()
            self.tableView_height.constant = CGFloat(array.count*110)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension MarketListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if StoreArray.count > 0 { return StoreArray.count } else { return .zero }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? MarketListTC else { return }
        
        let data = StoreArray[indexPath.row]
        setKingfisher(imageView: cell.storeMain_img, imageUrl: data.img_store_main, cornerRadius: 10)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? MarketListTC, StoreArray.count > 0 else { return }
        
        cancelKingfisher(imageView: cell.storeMain_img)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = StoreArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketListTC", for: indexPath) as! MarketListTC
        
        cell.storeName_label.text = data.store_name
        cell.storeRating_label.text = "5.0"
        cell.storeDistance_label.text = setDistance(lat: 37.662610, lng: 126.768678, target_lat: data.store_lat, target_lng: data.store_lng)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
