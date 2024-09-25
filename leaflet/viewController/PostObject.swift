//
//  PostObject.swift
//  leaflet
//
//  Created by 제현 on 7/15/24.
//

import UIKit

let category_name: [String] = ["맛집", "카페", "주점", "문화", "놀이", "풀빌라펜션", "대관대여", "뷰티미용", "키즈존", "액티비티", "애견", "운동", "호텔", "행사"]
let category_img: [String: String] = [
    "놀이": "cate_play",
    "대관대여": "cate_rental",
    "맛집": "cate_restaurant",
    "문화": "cate_culture",
    "뷰티미용": "cate_beauty",
    "애견": "cate_dog",
    "액티비티": "cate_activity",
    "운동": "cate_exercise",
    "주점": "cate_pub",
    "카페": "cate_cafe",
    "키즈존": "cate_kidszone",
    "풀빌라펜션": "cate_pension",
    "행사": "cate_event",
    "호텔": "cate_hotel",
]

class StoreData {
    
    var count_scrap: Int = 0
    var count_views: Int = 0
    var count_review: Int = 0
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
    var store_address1: String = ""
    var store_address2: String = ""
    var store_detail: String = ""
    var store_lat: Double = 0.0
    var store_lng: Double = 0.0
    var owner_name: String = ""
    var img_store_main: String = ""
    var img_store_sub: [String] = []
    var img_store_reg: String = ""
    var manager_name: String = ""
    var waiting_step: Int = 0
    var opening_hours: [OpeningHoursData] = []
    
    var upload_file: [String: [(file_name: String, file_data: Data, file_size: Int)]] = [:]
}

func setStore(storeDict: [String: Any]) -> StoreData {
    
    let storeValue: StoreData = StoreData()
    storeValue.count_scrap = storeDict["count_scrap"] as? Int ?? 0
    storeValue.count_views = storeDict["count_views"] as? Int ?? 0
    storeValue.count_review = storeDict["count_review"] as? Int ?? 0
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
    storeValue.store_address1 = storeDict["store_address1"] as? String ?? ""
    storeValue.store_address2 = storeDict["store_address2"] as? String ?? ""
    storeValue.store_detail = storeDict["store_detail"] as? String ?? ""
    storeValue.store_lat = storeDict["store_lat"] as? Double ?? 0.0
    storeValue.store_lng = storeDict["store_lng"] as? Double ?? 0.0
    storeValue.owner_name = storeDict["owner_name"] as? String ?? ""
    storeValue.img_store_main = storeDict["img_store_main"] as? String ?? ""
    storeValue.img_store_sub = storeDict["img_store_sub"] as? [String] ?? []
    storeValue.img_store_reg = storeDict["img_store_reg"] as? String ?? ""
    storeValue.manager_name = storeDict["manager_name"] as? String ?? ""
    storeValue.waiting_step = storeDict["waiting_step"] as? Int ?? 0
    (storeDict["opening_hours"] as? Array<[String: Any]> ?? []).forEach { dict in
        storeValue.opening_hours.append(setOpeningHours(openingHoursDict: dict))
    }
    
    return storeValue
}

struct OpeningHoursData {
    
    var close_time: String = ""
    var day_off: Bool = false
    var open_time: String = ""
}

func setOpeningHours(openingHoursDict: [String: Any]) -> OpeningHoursData {
    
    var openingHoursValue: OpeningHoursData = OpeningHoursData()
    openingHoursValue.close_time = openingHoursDict["close_time"] as? String ?? ""
    openingHoursValue.day_off = openingHoursDict["day_off"] as? Bool ?? false
    openingHoursValue.open_time = openingHoursDict["open_time"] as? String ?? ""
    
    return openingHoursValue
}

struct MenuData {
    
    var store_id: String = ""
    var store_name: String = ""
    var menu: [(top: Bool, id: String, name: String, price: Int, content: String, img_menu: String)] = []
    
    var upload_img_menu: [(file_name: String, file_data: Data, file_size: Int)] = []
}

func setMenu(menuDict: [String: Any]) -> MenuData {
    
    var menuValue: MenuData = MenuData()
    menuValue.store_id = menuDict["store_id"] as? String ?? ""
    menuValue.store_name = menuDict["store_name"] as? String ?? ""
    (menuDict["menu"] as? Array<[String: Any]> ?? []).forEach { dict in
        menuValue.menu.append((
            top: dict["top"] as? Bool ?? false,
            id: dict["id"] as? String ?? "",
            name: dict["name"] as? String ?? "",
            price: dict["price"] as? Int ?? 0,
            content: dict["content"] as? String ?? "",
            img_menu: dict["img_menu"] as? String ?? ""
        ))
    }
    
    return menuValue
}
