//
//  AppContext.swift
//  FastAppService_Example
//
//  Created by zhang pan on 2022/7/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
@_exported import CoreData
@_exported import FastExtension
@_exported import SnapKit

class AppContext {
    static var shared: AppContext = {
        let sha = AppContext()
        return sha
    }()
    
    var rootController: UIViewController? = nil
    
    private init() {}
    
    @available(iOS 13.0, *)
    var coreDataContext: NSManagedObjectContext? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            return delegate.persistentContainer.viewContext
        }
        return nil
    }
    
    @available(iOS 13.0, *)
    var container: NSPersistentCloudKitContainer? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            return delegate.persistentContainer
        }
        return nil
    }
    
    
    // Singleton code
    // ...
}

let AC = AppContext.shared
extension AppContext: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
