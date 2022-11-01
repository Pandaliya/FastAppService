//
//  AppCaseSet.swift
//  FastAppService_Example
//
//  Created by zhang pan on 2022/7/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

class AppCaseSet: ExampleCaseSet {
    var setTitle: String? = nil
    
    var cases: [ExampleCase] = []
    
    var isFold: Bool = false
    
    var foldImage: UIImage? {
        return nil
    }
    
    convenience init(title:String = "", fold:Bool = false) {
        self.init()
        self.setTitle = title
        self.isFold = fold
    }
    
    static var defaultSet: ExampleCaseSet {
        let ds = AppCaseSet.init(title: "苹果服务", fold: false)
        
        let sign = AppleSignCase.init()
        let coredata = CoreDataCase.init()
        let cloud = CloudCase.init()
        let location = LocationCase.init()
        let password = PasswordCase()
        
        ds.cases = [
            password,
            sign,
            coredata,
            cloud,
            location
        ]
        
        return ds
    }
}
