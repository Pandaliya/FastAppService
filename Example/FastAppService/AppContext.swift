//
//  AppContext.swift
//  FastAppService_Example
//
//  Created by zhang pan on 2022/7/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@_exported import FastExtension
@_exported import SnapKit

class AppContext {
    static var shared: AppContext = {
        let sha = AppContext()
        return sha
    }()
    private init() {}
    
    // Singleton code
    // ...
}

extension AppContext: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
