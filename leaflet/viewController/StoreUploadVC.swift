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
        segue.type = (sender == openTime_btn) ? "open" : "close"
        delegate.presentPanModal(segue)
    }
}

class StoreUploadVC: UIViewController {
    
    var StoreObject: StoreData = StoreData()
    var MenuObject: MenuData = MenuData()
    
    @IBAction func back_btn(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storeSub_iss: ImageSlideshow!
    @IBOutlet weak var storeSub_iss_ratio: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var storeMain_img: UIImageView!
    
    @IBOutlet weak var storeName_tf: UITextField!
    @IBOutlet weak var ownerName_tf: UITextField!
    @IBOutlet weak var storeRegNum_tf: UITextField!
    @IBOutlet weak var storeTel_tf: UITextField!
    @IBOutlet weak var storeAddress_tf: UITextField!
    @IBOutlet weak var category_btn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_height: NSLayoutConstraint!
    @IBOutlet weak var menuAdd_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreUploadVCdelegate = self
        setKeyboard()
        
        setImageSlideShew(imageView: storeSub_iss, imageUrls: StoreObject.img_store_sub, completionHandler: nil)
        storeSub_iss.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(store_img(_:))))
        storeSub_iss_ratio.constant = UIApplication.shared.statusBarFrame.height
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        roundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(store_img(_:))))
        setKingfisher(imageView: storeMain_img, imageUrl: StoreObject.img_store_main, cornerRadius: 47)
        
        storeName_tf.text = StoreObject.store_name
        ownerName_tf.text = StoreObject.owner_name
        storeRegNum_tf.text = StoreObject.store_reg_num
        storeTel_tf.text = StoreObject.store_tel
        storeAddress_tf.text = StoreObject.store_address
        category_btn.setTitle(StoreObject.store_category, for: .normal)
        category_btn.addTarget(self, action: #selector(category_btn(_:)), for: .touchUpInside)
        
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.delegate = self; tableView.dataSource = self
        tableView_height.constant = CGFloat(388+152*MenuObject.menu.count)
        
        MenuObject.upload_img_menu.removeAll()
        MenuObject.menu.forEach { _ in MenuObject.upload_img_menu.append((file_name: "", file_data: Data(), file_size: 0)) }
        MenuObject.menu.enumerated().forEach { i, data in
            imageUrlStringToData(from: data.img_menu) { mimeType, imgData in
                DispatchQueue.main.async {
                    self.MenuObject.upload_img_menu[i] = (file_name: "img_menu\(i).\((mimeTypes.filter { $0.value == mimeType }.map { $0.key }).first ?? "")", file_data: imgData ?? Data(), file_size: imgData?.count ?? 0)
                    self.tableView.reloadRows(at: [IndexPath(row: i, section: 2)], with: .none)
                }
            }
        }
        
        menuAdd_btn.addTarget(self, action: #selector(menuAdd_btn(_:)), for: .touchUpInside)
    }
    
    @objc func store_img(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범에서 메인이미지 선택", style: .default, handler: { _ in
            self.setPhoto(max: 1) { photo in
                self.StoreObject.upload_file["img_store_main"] = photo
                self.storeMain_img.layer.cornerRadius = 47
                self.storeMain_img.image = UIImage(data: photo[0].file_data) ?? UIImage()
            }
        }))
        alert.addAction(UIAlertAction(title: "앨범에서 서브이미지 선택", style: .default, handler: { _ in
            self.setPhoto(max: 10) { photos in
                self.StoreObject.upload_file["img_store_sub"] = photos
                var inputs: [ImageSource] = []
                photos.forEach { photo in inputs.append(ImageSource(image: UIImage(data: photo.file_data) ?? UIImage())) }
                self.storeSub_iss.setImageInputs(inputs)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
 
    @objc func category_btn(_ sender: UIButton) {
        presentPanModal(storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC)
    }
    
    @objc func menuAdd_btn(_ sender: UIButton) {
        
        tableView.beginUpdates()
        MenuObject.menu.append((top: false, id: "", name: "", price: 0, content: "", img_menu: ""))
        MenuObject.upload_img_menu.append((file_name: "", file_data: Data(), file_size: 0))
        tableView.insertRows(at: [IndexPath(row: MenuObject.menu.count-1, section: 2)], with: .none)
        tableView_height.constant = CGFloat(388+152*MenuObject.menu.count)
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
        } else if section == 2, MenuObject.menu.count > 0, MenuObject.menu.count == MenuObject.upload_img_menu.count {
            return MenuObject.menu.count
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? StoreUploadTC else { return }
        
        if indexPath.section == 2 {
            let data = MenuObject.upload_img_menu[indexPath.row]
            cell.menuImage_btn.setImage(UIImage(data: data.file_data), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? StoreUploadTC else { return }
        
        if indexPath.section == 2 {
            cell.removeFromSuperview()
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
            let data = MenuObject.menu[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreUploadTC3", for: indexPath) as! StoreUploadTC
            cell.delegate = self
            
            cell.menuName_tf.text = data.name
            cell.menuPrice_tf.text = (data.price != 0) ? String(data.price) : ""
            cell.menuContent_tf.text = data.content
            ([cell.menuName_tf, cell.menuPrice_tf, cell.menuContent_tf] as [UITextField]).forEach { tf in
                tf.tag = indexPath.row; tf.addTarget(self, action: #selector(menu_tf(_:)), for: .editingChanged)
            }
            cell.menuImage_btn.imageView?.contentMode = .scaleAspectFill
            cell.menuImage_btn.tag = indexPath.row; cell.menuImage_btn.addTarget(self, action: #selector(menuImage_btn(_:)), for: .touchUpInside)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func menu_tf(_ sender: UITextField) {
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 2)) as? StoreUploadTC else { return }
        
        if sender == cell.menuName_tf {
            MenuObject.menu[sender.tag].name = cell.menuName_tf.text!
        } else if sender == cell.menuPrice_tf {
            MenuObject.menu[sender.tag].price = Int(cell.menuPrice_tf.text!) ?? 0
        } else if sender == cell.menuContent_tf {
            MenuObject.menu[sender.tag].content = cell.menuContent_tf.text!
        }
    }
    
    @objc func menuImage_btn(_ sender: UIButton) {
        
        view.endEditing(true)
        
        setPhoto(max: 1) { photo in
            UIView.setAnimationsEnabled(false)
            self.MenuObject.upload_img_menu[sender.tag] = (file_name: "img_menu\(sender.tag).\(photo[0].file_name)", file_data: photo[0].file_data, file_size: photo[0].file_data.count)
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 2)], with: .none)
            UIView.setAnimationsEnabled(true)
        }
    }
}
