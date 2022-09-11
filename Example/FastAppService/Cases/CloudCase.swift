//
//  CloudCase.swift
//  FAService
//
//  Created by pan zhang on 2022/7/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CloudKit
import UIKit


class CloudCase: ExampleCase {
    var title: String = "iCloudKit"
    var callBack: (() -> ())? = nil
    
    lazy var container: CKContainer = {
        return CKContainer(identifier: "iCloud.page3App.FastAppService")
    }()
    
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
//        saveRecord(isPrivate: false)
        fetchRecord()
//        checkoutCloudCountStatus()
        return true
    }
    
    /// 保存记录到iCloud
    func saveRecord(isPrivate: Bool = true) {
        // 创建索引
        let recordId = CKRecordID.init(recordName: "page3App.zhangpan") // 每条记录的recordName是唯一的
        let record = CKRecord(recordType: "BrowsingHistory", recordID: recordId)
        
        record.setValuesForKeys([
            "datetime" : Date().description,
            "conent_json_string" : "{\"id\": 1200}",
            "user_idef" : "ckuabdugrekdsad001mnjsajd"
        ])
        
        let container = CKContainer(identifier: "iCloud.page3App.FastAppService")
        let database = isPrivate ? container.privateCloudDatabase : container.publicCloudDatabase
        database.save(record) { reco, err in
            if err != nil {
                debugPrint("save record to \(isPrivate ? "privateCloudDatabase" : "publicCloudDatabase") error: \(err.debugDescription)")
            } else {
                debugPrint("save record to \(isPrivate ? "privateCloudDatabase" : "publicCloudDatabase") success: ", reco ?? "nil")
            }
        }
    }
    
    // 拉取记录
    func fetchRecord() {
        // 根据recordname
//        let recordId = CKRecordID.init(recordName: "EC5DA93C-6503-4E49-8CEA-E6903FDD94BB")
//        container.publicCloudDatabase.fetch(withRecordID: recordId) { record, err in
//            guard err == nil else {
//                debugPrint("fetchRecord error:  \(err!.localizedDescription)")
//                return
//            }
//
//            debugPrint("fetchRecord success: ", record ?? "nil")
//        }
        
        // 条件查询
        let predicate = NSPredicate(format: "user_idef = %@", "ckuabdugrekdsad001mnjsajd")
        let qurey = CKQuery.init(recordType: "BrowsingHistory", predicate: predicate)
        
        container.publicCloudDatabase.perform(qurey, inZoneWith: nil) { records, err in
            guard err == nil else {
                debugPrint("predicate fetchRecord error:  \(err!.localizedDescription)")
                return
            }
            
            debugPrint("predicate fetchRecord success: ", records ?? "nil")
        }
        
//        container.publicCloudDatabase.fetch(withQuery: qurey) { result in
//            switch result {
//            case .success(let results, let cursor):
//                debugPrint("success: ", results ?? "nil ")
//            case .failure(let error):
//                debugPrint("failed with error:", error)
//            }
//        }
//        container.publicCloudDatabase.fetch(withQuery: qurey, inZoneWith: nil, desiredKeys: nil, resultsLimit: 1) { result in
//            switch result {
//            case .success(let results, let cursor):
//                debugPrint("success")
//            case .failure(let error):
//                debugPrint("failed with error:", error)
//            }
//        }
        
    }
    
    // 检查iCloud登录状态
    func checkoutCloudCountStatus() {
        let container = CKContainer(identifier: "iCloud.page3App.FastAppService")
        container.accountStatus { status, err in
            guard err == nil else {
                debugPrint("checkoutCloudCountStatus err", err!.localizedDescription.debugDescription)
                return
            }
            
            if status == .noAccount {
                DispatchQueue.main.async {
                    let message =
                        """
                        Sign in to your iCloud account to write records.
                        On the Home screen, launch Settings, tap Sign in to your
                        iPhone/iPad, and enter your Apple ID. Turn iCloud Drive on.
                        """
                    let alert = UIAlertController(
                        title: "Sign in to iCloud",
                        message: message,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    AC.rootController?.present(alert, animated: true)
                }
            } else if status == .available {
                debugPrint("iCloud account is available")
            }
        }
    }
}
