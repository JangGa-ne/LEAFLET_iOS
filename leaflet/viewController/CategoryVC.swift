//
//  CategoryVC.swift
//  leaflet
//
//  Created by 제현 on 7/30/24.
//

import UIKit
import PanModal

class CategoryVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    var category: String = ""
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var cancel_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.layer.cornerRadius = device_radius
        
        pickerView.delegate = self; pickerView.dataSource = self
        
        ([submit_btn, cancel_btn] as [UIButton]).enumerated().forEach { i, btn in
            btn.tag = i; btn.addTarget(self, action: #selector(btn(_:)), for: .touchUpInside)
        }
    }
    
    @objc func btn(_ sender: UIButton) {
        
        if sender.tag == 0, let delegate = StoreUploadVCdelegate {
            delegate.category_btn.setTitle(category, for: .normal)
        }; dismiss(animated: true, completion: nil)
    }
}

extension CategoryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if category_name.count > 0 { return category_name.count } else { return .zero }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let viewWidth = pickerView.bounds.width
        let viewHeight = pickerView.rowSize(forComponent: component).height
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(imageView)
        
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(label)
        
        imageView.image = UIImage(named: category_img[category_name[row]] ?? "") ?? UIImage()
        label.text = category_name[row]
        
        let stackViewWidth = viewHeight+10+stringWidth(text: label.text!)
        let stackView = UIStackView(frame: CGRect(x: pickerView.bounds.midX-stackViewWidth/2, y: 0, width: stackViewWidth, height: viewHeight))
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        customView.addSubview(stackView)
        
        return customView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = category_name[row]
    }
}

extension CategoryVC: PanModalPresentable {
    
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

