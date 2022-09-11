//
//  FastLocation.swift
//  FastAppService
//
//  Created by pan zhang on 2022/7/25.
//

import Foundation
import CoreLocation

public struct FastCoordinate {
    let latitude: Double   // 经度
    let longitude: Double  // 纬度
    let altitude: Double   // 高度
}

public protocol FastLocationDelegate {
    
}

public final class FastLocation: NSObject {
    public static var shared: FastLocation = {
        let sha = FastLocation()
        return sha
    }()
    
    private override init() {}
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        lm.distanceFilter = 100.0
        return lm
    }()
    
    
    public static func checkLocationLimit(showAlert: Bool = false) -> Bool {
        // 检查定位服务是否开启
        if CLLocationManager.locationServicesEnabled() {
            // 检查当前App是否有位置获取权限
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                return true
            }
        }
        
        if showAlert { self.showLocationAuthAlert() }
        
        return false
    }
    
    public static func showLocationAuthAlert() {
        let alert = UIAlertController(
            title: "允许定位",
            message: "在设置中开启定位权限",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction.init(title: "开启", style: .default, handler: { _ in
            let _ = UIApplication.fe.toAppSetting()
        }))
        
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel))
        UIWindow.fe.currentWindow?.rootViewController?.present(alert, animated: true)
    }
    
    /// 开启位置监控
    public func startLocationMinitor() {
        guard FastLocation.checkLocationLimit() else {
            return
        }
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension FastLocation: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            debugPrint("locationManagerDidChangeAuthorization: ", manager.authorizationStatus)
        } else {
            debugPrint("locationManagerDidChangeAuthorization: ", CLLocationManager.authorizationStatus())
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("didUpdateLocations:", locations)
        guard let currLocation = locations.last else {
            return
        }
        
        debugPrint("经度：\(currLocation.coordinate.latitude)； 纬度: \(currLocation.coordinate.longitude); 高度: \(currLocation.altitude)")
        let c: FastCoordinate = FastCoordinate.init(
            latitude: currLocation.coordinate.latitude,
            longitude: currLocation.coordinate.longitude,
            altitude: currLocation.altitude
        )
        debugPrint("Coordinate: ", c)
        
        self.geoDecode(location: currLocation)
    }
    
    public func geoDecode(location: CLLocation) {
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location) { placeMarks, err in
            guard err == nil else {
                debugPrint("GEO reverseGeocodeLocation error", err!)
                return
            }
            guard let mark = placeMarks?.last else {
                debugPrint("NO Location Reverse")
                return
            }
            
            let address = "\(mark.locality ?? "")\(mark.subLocality ?? "")\(mark.name ?? "")"
            debugPrint(
            """
            城市: \(mark.locality ?? "nil")
            国家: \(mark.country ?? "nil")
            位置: \(mark.subLocality ?? "nil")
            街道: \(mark.thoroughfare ?? "nil")
            具体地址: \(mark.name ?? "nil")
            完整地址: \(address)
            """)
            
            debugPrint(mark)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("locationManager didFailWithError: ", error )
    }
    
}
