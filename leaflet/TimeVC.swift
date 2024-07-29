//
//  TimeVC.swift
//  leaflet
//
//  Created by 제현 on 7/29/24.
//

import UIKit
import PanModal

class TimeVC: UIViewController {
    
    var StoreUploadTCdelegate: StoreUploadTC? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var cancel_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.layer.cornerRadius = device_radius
        
        ([submit_btn, cancel_btn] as [UIButton]).enumerated().forEach { i, btn in
            btn.tag = i; btn.addTarget(self, action: #selector(btn(_:)), for: .touchUpInside)
        }
    }
    
    @objc func btn(_ sender: UIButton) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm a"
        
        if sender.tag == 0 {
            if let delegateTC = StoreUploadTCdelegate {
                delegateTC.openTime_btn.setTitle(dateFormat.string(from: timePicker.date), for: .normal)
            }
        }; dismiss(animated: true, completion: nil)
    }
}

extension TimeVC: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var allowsTapToDismiss: Bool {
        return false
    }
    
    var panModalBackgroundColor: UIColor {
        return .black.withAlphaComponent(0.3)
    }
}
