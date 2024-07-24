//
//  Vc.swift
//  leaflet
//
//  Created by 제현 on 7/23/24.
//

import UIKit

class StoreUploadTC: UITableViewCell {
    
    @IBOutlet weak var menuName_tf: UITextField!
    @IBOutlet weak var menuPrice_tf: UITextField!
    @IBOutlet weak var menuContent_tf: UITextField!
    @IBOutlet weak var menu_img: UIImageView!
}

class StoreUploadVC: UIViewController {
    
    var menu_data: [(menu_title: String, menu_price: Int, menu_content: String, img_menu: UIImage)] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var storeName_tf: UITextField!
    @IBOutlet weak var ceoName_tf: UITextField!
    @IBOutlet weak var storeRegNum_tf: UITextField!
    @IBOutlet weak var storeTel_tf: UITextField!
    @IBOutlet weak var storeAddress_tf: UITextField!
    @IBOutlet weak var category_tf: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.delegate = self; tableView.dataSource = self
    }
    
    @objc func add_btn(_ sender: UIButton) {
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: menu_data.count, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension StoreUploadVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menu_data.count > 0 { return menu_data.count } else { return .zero }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreUploadTC", for: indexPath) as! StoreUploadTC
        
        return cell
    }
}
