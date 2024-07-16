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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SplashVCdelegate = self
        
        DispatchQueue.main.async {
            self.segueViewController(identifier: "HomeVC")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}
