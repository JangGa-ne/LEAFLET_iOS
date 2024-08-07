//
//  PostRequest.swift
//  leaflet
//
//  Created by 제현 on 7/15/24.
//

import UIKit
import FirebaseFirestore
//import FirebaseStorage

var StoreArray: [StoreData] = []
var StoreObject: StoreData = StoreData()

func requestSignIn(store_id: String = "test123", store_pw: String = "test123", completionHandler: @escaping ((Int) -> Void)) {
    
    Firestore.firestore().collection("store").whereField("store_id", isEqualTo: store_id).whereField("store_pw", isEqualTo: store_pw).getDocuments { responses, error in
        if error == nil {
            responses?.documents.forEach { doc in
                StoreObject = setStore(storeDict: doc.data())
            }; completionHandler(200)
        } else {
            print(error?.localizedDescription as Any)
            completionHandler(500)
        }
    }
}

func requestGetStore(limit: Int = 10000, category_name: String = "", completionHandler: @escaping (([StoreData], Int) -> Void)) {
    
    var StoreArray: [StoreData] = []
    var ref: Query = Firestore.firestore().collection("store").limit(to: limit)
    if category_name != "" {
        ref = ref.whereField("store_category", isEqualTo: category_name)
    }
    
    ref.getDocuments { responses, error in
        if error == nil {
            responses?.documents.forEach { doc in
                StoreArray.append(setStore(storeDict: doc.data()))
            }; completionHandler(StoreArray, 200)
        } else {
            print(error?.localizedDescription as Any)
            completionHandler([], 500)
        }
    }
}

func requestRegisterStore(params: [String: Any], completionHandler: @escaping ((Int) -> Void)) {
    
    Firestore.firestore().collection("store").document(StoreObject.store_id).setData(params, merge: true) { _ in
        
    }
}

func requestGetMenu(store_id: String, completionHandler: @escaping ((MenuData, Int) -> Void)) {
    
    var MenuObject: MenuData = MenuData()
    
    Firestore.firestore().collection("menu").document(store_id).getDocument { response, error in
        if error == nil, let response = response {
            MenuObject = setMenu(menuDict: response.data() ?? [:])
            completionHandler(MenuObject, 200)
        } else {
            print(error?.localizedDescription as Any)
            completionHandler(MenuObject, 500)
        }
    }
}

func requestPutMenu() {
    
    let params: [String: Any] = [
        "menu_type": [
            "menu_id": "",
            "menu_title": "",
            "menu_content": "",
            "menu_price": 0,
            "img_menu": "",
        ]
    ]
}

func requestCounting() {
    
    let params: [String: Any] = [
        "waiting_step": 0,
        "count_store": 0,
        "count_scrap": 0,
    ]
}
