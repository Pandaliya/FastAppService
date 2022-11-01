//
//  PasswordCase.swift
//  FAService
//
//  Created by pan zhang on 2022/11/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import FastAppService


class PasswordCase: ExampleCase {
    var title: String = "密码验证"
    var callBack: (() -> ())? = nil
    var hasNext: Bool = true
    
    
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
        
        self.routerToFuncController()
        return true
    }
    
    func fingger() {
        debugPrint("func fingger")
        let _ = FastPassword.shared.localFingerAuthentication { fingerData, error in
            if let fingerData = fingerData {
                debugPrint("fingerData: \(String(describing: NSString(data: fingerData, encoding: NSUTF8StringEncoding)))")
            }
        }
    }
}

extension PasswordCase {
    var funcCaseTitles: [String] {
        return [
            "指纹/面容验证",
            "开启验证",
            "指纹面纹数据是否改变",
        ]
    }
    
    var funcCallback: ((FEFuncCaseTableController, Int) -> (Bool))? {
        return {[weak self] controller, index in
            guard let self = self else { return false }
            switch index {
            case 0:
                self.fingger()
                break
            default:
                break
            }
            
            return true
        }
    }
}
