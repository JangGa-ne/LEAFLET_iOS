//
//  PostObject.swift
//  leaflet
//
//  Created by 제현 on 7/15/24.
//

import UIKit

class StoreData {
    
    var store_category: String = ""
    var store_cash: Int = 0
    var store_color: String = ""
    var store_id: String = ""
    var store_pw: String = ""
    var store_tag: [String] = []
    var store_name: String = ""
    var store_tel: String = ""
    var store_reg_num: String = ""
    var store_opening: String = ""
    var store_address: String = ""
    var store_lat: Double = 0.0
    var store_lng: Double = 0.0
    var owner_name: String = ""
    var img_store_main: String = ""
    var img_store_sub: [String] = []
    var img_store_reg: String = ""
    var manager_name: String = ""
    var waiting_step: Int = 0
    
    func setStore(storeDict: [String: Any]) -> StoreData {
        
        var storeValue: StoreData = StoreData()
        storeValue.store_category = storeDict["store_category"] as? String ?? ""
        storeValue.store_cash = storeDict["store_cash"] as? Int ?? 0
        storeValue.store_color = storeDict["store_color"] as? String ?? ""
        storeValue.store_id = storeDict["store_id"] as? String ?? ""
        storeValue.store_pw = storeDict["store_pw"] as? String ?? ""
        storeValue.store_tag = storeDict["store_tag"] as? [String] ?? []
        storeValue.store_name = storeDict["store_name"] as? String ?? ""
        storeValue.store_tel = storeDict["store_tel"] as? String ?? ""
        storeValue.store_reg_num = storeDict["store_reg_num"] as? String ?? ""
        storeValue.store_opening = storeDict["store_opening"] as? String ?? ""
        storeValue.store_address = storeDict["store_address"] as? String ?? ""
        storeValue.store_lat = storeDict["store_lat"] as? Double ?? 0.0
        storeValue.store_lng = storeDict["store_lng"] as? Double ?? 0.0
        storeValue.owner_name = storeDict["owner_name"] as? String ?? ""
        storeValue.img_store_main = storeDict["img_store_main"] as? String ?? ""
        storeValue.img_store_sub = storeDict["img_store_sub"] as? [String] ?? []
        storeValue.img_store_reg = storeDict["img_store_reg"] as? String ?? ""
        storeValue.manager_name = storeDict["manager_name"] as? String ?? ""
        storeValue.waiting_step = storeDict["waiting_step"] as? Int ?? 0
        
        return storeValue
    }
}
