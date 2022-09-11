//
//  LocationCase.swift
//  FAService
//
//  Created by pan zhang on 2022/7/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import FastAppService

class LocationCase: ExampleCase {
    var title: String = "获取位置"
    var callBack: (() -> ())? = nil
    
    convenience init(callBack: (() -> ())?) {
        self.init()
        self.callBack = callBack
    }
    
    func caseAction() -> Bool {
        if let callBack = callBack {
            debugPrint("\(type(of: self)) Executing: call back")
            callBack()
        }
        debugPrint("\(type(of: self))  Executing: case action")
        
//        checkLimit()
        startMonitor()
        
        return true
    }
    
    private func checkLimit() {
        let res = FastLocation.checkLocationLimit(showAlert: true)
        if res  {
            debugPrint("have location auth")
        } else {
            debugPrint("don't have location auth")
        }
    }
    
    private func startMonitor() {
        FastLocation.shared.startLocationMinitor()
    }
}
