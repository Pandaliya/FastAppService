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
    
    public static func createWithLocation(location: CLLocation) -> FastCoordinate {
        return self.init(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude
        )
    }
}

public struct FateGeoInfo {
    let mark: CLPlacemark
    
    var country: String? // 国家
    var city: String?    // 城市
    var area: String?    // 区县
    var address: String? // 街道地址
    
    init(mark: CLPlacemark) {
        self.mark = mark
        self.country = mark.country
        self.city = mark.locality
        self.area = mark.subLocality
        self.address = mark.thoroughfare
    }
    
}

public protocol FastLocationDelegate: AnyObject {
    func locationUpdate(coordinate: FastCoordinate)
    func geoInfoUpdate(place: FateGeoInfo)
}

public extension FastLocationDelegate {
    func geoInfoUpdate(place: FateGeoInfo) {
        let mark = place.mark
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
    }
    func locationUpdate(coordinate: FastCoordinate) {
        debugPrint("locationUpdate: 经度：\(coordinate.latitude)； 纬度: \(coordinate.longitude); 高度: \(coordinate.altitude)")
    }
}

public final class FastLocation: NSObject {
    
    public static var shared: FastLocation = {
        let sha = FastLocation()
        return sha
    }()
    
    private override init() {}
    
    private var locationCallback: ((CLLocation?, Error?)->())? = nil
    private weak var delegate: FastLocationDelegate? = nil
    private var geoEnable: Bool = false
    
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
    
    public func updateGeoEnable(enable:Bool) {
        self.geoEnable = enable
    }
    
    public func replaceDelegate(_ delegate: FastLocationDelegate? = nil) {
        self.delegate = delegate
    }
    
    /// 开启位置监控
    public func startLocationMinitor(completion: ((CLLocation?, Error?)->())? = nil) {
        guard FastLocation.checkLocationLimit() else {
            return
        }
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationCallback = completion
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
            // 未获取位置信息
            if let c = self.locationCallback {
                c(nil, nil)
                self.locationCallback = nil // 打破循环引用
            }
            return
        }
        
        if let c = self.locationCallback {
            c(currLocation, nil)
            self.locationCallback = nil // 打破循环引用
        }
        
        if let d = self.delegate {
            d.locationUpdate(coordinate: FastCoordinate.createWithLocation(location: currLocation))
        }
        
        if self.geoEnable  {
            self.geoDecode(location: currLocation)
        }
    }
    
    public func geoDecode(location: CLLocation) {
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location) {[weak self] placeMarks, err in
            guard let self = self else { return }
            
            guard err == nil else {
                debugPrint("GEO reverseGeocodeLocation error", err!)
                return
            }
            guard let mark = placeMarks?.last else {
                debugPrint("NO Location Reverse")
                return
            }
            
            if let d = self.delegate {
                d.geoInfoUpdate(place: FateGeoInfo.init(mark: mark))
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("locationManager didFailWithError: ", error )
        if let c = self.locationCallback {
            c(nil, error)
            self.locationCallback = nil // 打破循环引用
        }
    }
}
