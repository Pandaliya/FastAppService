//
//  FastCoreData.swift
//  FastAppService
//
//  Created by pan zhang on 2022/7/15.
//

import Foundation
import CoreData
import CloudKit

public protocol CoreDataCloudDelegate {
    
}

public final class FastCoreData: NSObject {
    public static var shared: FastCoreData = {
        let sha = FastCoreData()
        return sha
    }()
    private override init() {}
    
    public var container: CKContainer {
        return CKContainer.default()
    }
    
    public var zoneID: CKRecordZoneID?
    
    @available(iOS 13.0, *)
    public func autoMergeChange(container:NSPersistentCloudKitContainer) {
        // 自动合并服务端数据
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        /* 合并冲突策略
         NSMergeByPropertyStoreTrumpMergePolicy：逐属性比较，如果持久化数据和内存数据都改变且冲突，持久化数据胜出
         NSMergeByPropertyObjectTrumpMergePolicy：逐属性比较，如果持久化数据和内存数据都改变且冲突，内存数据胜出
         NSOverwriteMergePolicy：内存数据永远胜出
         NSRollbackMergePolicy：持久化数据永远胜出
         */
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            // fatalError Release环境仍然有效，而断言release环境无效
            fatalError("Failed to pin viewContext to the current generation:\(error)")
        }
    }
}


extension FastCoreData: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}


