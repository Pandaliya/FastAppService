//
//  AppleSignCase.swift
//  FastAppService_Example
//
//  Created by zhang pan on 2022/7/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import FastAppService

class AppleSignCase: ExampleCase {
    var title: String = "Sign with apple"
    var callBack: (() -> ())? = nil
    var hasNext: Bool { return true }
    
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
        return true
    }
    
    func configView(view: UIView) -> Bool {
        if #available(iOS 13.0.0, *) {
            if let btn = SignWithApple.shared.signButton{
                view.addSubview(btn)
                btn.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview().inset(128)
                }
            }
            return true
        }
        
        return false
    }
    
    var controller: UIViewController? {
        let vc = CaseViewController.init(exam: self)
        return vc
    }
}
