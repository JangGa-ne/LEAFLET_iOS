//
//  MarketListVC.swift
//  leaflet
//
//  Created by 제현 on 8/8/24.
//

import UIKit
import ImageSlideshow

class MarketListTC: UITableViewCell {
    
    
}

class MarketListVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        tableView_height.constant = CGFloat(100*110)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension MarketListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketListTC", for: indexPath) as! MarketListTC
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
