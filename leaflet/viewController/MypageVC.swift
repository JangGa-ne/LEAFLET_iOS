//
//  MypageVC.swift
//  leaflet
//
//  Created by 제현 on 8/12/24.
//

import UIKit

class MypageTC: UITableViewCell {
    
    @IBOutlet weak var title_label: UILabel!
}

class MypageVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var main_img: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var edit_btn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.separatorStyle = .none
//        tableView.contentInset = .zero
//        tableView.delegate = self; tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension MypageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageTC", for: indexPath) as! MypageTC
        
        return cell
    }
}
