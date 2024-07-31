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

func requestGetStore(limit: Int = 10000, completionHandler: @escaping ((Int) -> Void)) {
    
    Firestore.firestore().collection("store").limit(to: limit).getDocuments { response, error in
        if error == nil {
            response?.documents.forEach { doc in
                StoreArray.append(setStore(storeDict: doc.data()))
            }; completionHandler(200)
        } else {
            print(error?.localizedDescription as Any)
            completionHandler(500)
        }
    }
}

func requestRegisterStore(params: [String: Any], completionHandler: @escaping ((Int) -> Void)) {
    
    Firestore.firestore().collection("store").document(StoreObject.store_id).setData(params, merge: true) { _ in
        
    }
}

func requestMenu() {
    
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
