//
//  s_distance.swift
//  leaflet
//
//  Created by 제현 on 9/25/24.
//

import CoreLocation
import UIKit

func setDistance(lat: Double, lng: Double, target_lat: Double, target_lng: Double) -> String {
    // 두 좌표를 정의합니다.
    let coordinate1 = CLLocation(latitude: lat, longitude: lng)
    let coordinate2 = CLLocation(latitude: target_lat, longitude: target_lng)
    // 두 좌표 간의 거리 계산
    let distanceInMeters = coordinate1.distance(from: coordinate2)
    // 거리 출력
    if distanceInMeters >= 1000 {
        let distanceInKm = distanceInMeters / 1000
        return "\(numberFormat.string(from: Int(distanceInKm) as NSNumber) ?? "0")km"
    } else {
        return "\(numberFormat.string(from: Int(distanceInMeters) as NSNumber) ?? "0")m"
    }
}
