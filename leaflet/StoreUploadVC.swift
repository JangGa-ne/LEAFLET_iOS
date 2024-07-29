//
//  Vc.swift
//  leaflet
//
//  Created by 제현 on 7/23/24.
//

import UIKit
import ImageSlideshow
import PanModal

class StoreUploadTC: UITableViewCell {
    
    var indexpath_row: Int = 0
    var delegate: StoreUploadVC = StoreUploadVC()
    
    @IBOutlet weak var day_label: UILabel!
    @IBOutlet weak var hoilday_btn: UIButton!
    @IBOutlet weak var openTime_btn: UIButton!
    @IBOutlet weak var closeTime_btn: UIButton!
    
    @IBOutlet weak var menuName_tf: UITextField!
    @IBOutlet weak var menuPrice_tf: UITextField!
    @IBOutlet weak var menuContent_tf: UITextField!
    @IBOutlet weak var menuImage_btn: UIButton!
    
    @objc func time_btn(_ sender: UIButton) {
        
        let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "TimeVC") as! TimeVC
        segue.StoreUploadTCdelegate = self
        delegate.presentPanModal(segue)
    }
}

class StoreUploadVC: UIViewController {
    
    var menu_data: [(menu_title: String, menu_price: Int, menu_content: String, img_menu: UIImage)] = []
    
    @IBAction func back_btn(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var store_iss: ImageSlideshow!
    @IBOutlet weak var store_iss_ratio: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var storeName_tf: UITextField!
    @IBOutlet weak var ceoName_tf: UITextField!
    @IBOutlet weak var storeRegNum_tf: UITextField!
    @IBOutlet weak var storeTel_tf: UITextField!
    @IBOutlet weak var storeAddress_tf: UITextField!
    @IBOutlet weak var category_tf: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_height: NSLayoutConstraint!
    @IBOutlet weak var menuAdd_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreUploadVCdelegate = self
        setKeyboard()
        
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.delegate = self; tableView.dataSource = self
        tableView_height.constant = CGFloat(388+152*menu_data.count)
        
        menuAdd_btn.addTarget(self, action: #selector(menuAdd_btn(_:)), for: .touchUpInside)
    }
    
    @objc func menuAdd_btn(_ sender: UIButton) {
        
        tableView.beginUpdates()
        menu_data.append((menu_title: "", menu_price: 0, menu_content: "", img_menu: UIImage()))
        tableView.insertRows(at: [IndexPath(row: menu_data.count-1, section: 2)], with: .none)
        tableView_height.constant = CGFloat(388+152*menu_data.count)
        tableView.endUpdates()
        
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension StoreUploadVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else if section == 1 {
            return 1
        } else if section == 2, menu_data.count > 0 {
            return menu_data.count
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreUploadTC1", for: indexPath) as! StoreUploadTC
            cell.indexpath_row = indexPath.row
            cell.delegate = self
            
            cell.day_label.text = ["월", "화", "수", "목", "금", "토", "일"][indexPath.row]
            cell.openTime_btn.tag = indexPath.row; cell.openTime_btn.addTarget(cell, action: #selector(cell.time_btn(_:)), for: .touchUpInside)
            cell.closeTime_btn.tag = indexPath.row; cell.closeTime_btn.addTarget(cell, action: #selector(cell.time_btn(_:)), for: .touchUpInside)
            
            return cell
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "StoreUploadTC2", for: indexPath) as! StoreUploadTC
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreUploadTC3", for: indexPath) as! StoreUploadTC
            cell.delegate = self
            
            cell.menuImage_btn.setImage(menu_data[indexPath.row].img_menu, for: .normal)
            cell.menuImage_btn.imageView?.contentMode = .scaleAspectFill
            cell.menuImage_btn.tag = indexPath.row; cell.menuImage_btn.addTarget(self, action: #selector(menuImage_btn(_:)), for: .touchUpInside)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func menuImage_btn(_ sender: UIButton) {
        
        setPhoto(max: 1) { photo in
            UIView.setAnimationsEnabled(false)
            self.menu_data[sender.tag].img_menu = UIImage(data: photo[0].file_data) ?? UIImage()
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2)], with: .none)
            UIView.setAnimationsEnabled(true)
        }
    }
}
