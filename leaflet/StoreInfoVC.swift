//
//  StoreInfoVC.swift
//  leaflet
//
//  Created by 제현 on 7/22/24.
//

import UIKit
import PanModal

class StoreInfoVC: UIViewController {
    
    @IBAction func back_btn(_  sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openingTime_label: UILabel!
    @IBOutlet weak var storeTel_label: UILabel!
    @IBOutlet weak var storeAddress_label: UILabel!
    @IBOutlet weak var storeType_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
