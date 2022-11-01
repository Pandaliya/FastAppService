//
//  FastNotification.swift
//  FastAppService
//
//  Created by pan zhang on 2022/7/21.
//

import Foundation

class FastNotification {
    static var shared: FastNotification = {
        let sha = FastNotification()
        return sha
    }()
    private init() {}
    
    // Singleton code
    // ...
}

extension FastNotification: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
