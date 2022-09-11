//
//  FaskCloudKit.swift
//  FastAppService
//
//  Created by pan zhang on 2022/7/21.
//

import Foundation
import CloudKit
import FastExtension

public final class FaskCloudKit: NSObject {
    static var shared: FaskCloudKit = {
        let sha = FaskCloudKit()
        return sha
    }()
    private override init() {}
    
    // Singleton code
    // ...
    func checkCloudAuth(containerIdef:String? = nil, showAlert:Bool = true) -> Bool {
        let container = (containerIdef == nil) ? CKContainer.default() : CKContainer(identifier: containerIdef!)
        container.accountStatus { status, err in
            guard err == nil else {
                debugPrint("checkoutCloudCountStatus err", err!.localizedDescription.debugDescription)
                if showAlert {
                    UIAlertController.fe.showMessageAlert(title: nil, message: "iCloud 不可用", confirmTitle: "确定")
                }
                return
            }
            
            switch status {
            case .couldNotDetermine:
                break
            case .available:
                break
            case .restricted:
                break
            case .noAccount:
                UIAlertController.fe.showAlert(
                    title: "iCloud不可用",
                    message: "您未登录iCloud账号, 是否登录？",
                    cancelTitle: "取消",
                    confirmTitle: "去登录"
                )
            case .temporarilyUnavailable:
                UIAlertController.fe.showMessageAlert(title: nil, message: "iCloud 暂时不可用", confirmTitle: "确定")
            }
        }
        return false
    }
}

extension FaskCloudKit: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

