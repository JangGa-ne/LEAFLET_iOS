//
//  SplashVC.swift
//  leaflet
//
//  Created by 장 제현 on 7/11/24.
//

import UIKit

class SplashVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var title_label: UILabel!
    
    override func loadView() {
        super.loadView()
        
        title_label.font = UIFont(name: "GmarketSansBold", size: 18)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SplashVCdelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.segueViewController(identifier: "HomeVC")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}
