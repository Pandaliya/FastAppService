//
//  SignWithApple.swift
//  FastAppService
//
//  Created by pan zhang on 2022/7/15.
//

import Foundation
import AuthenticationServices

@available(iOS 13.0, *)
open class SignWithApple {
    public static var shared: SignWithApple = {
        let sha = SignWithApple()
        return sha
    }()
    private init() {}
    
    public lazy var signButton:ASAuthorizationAppleIDButton? = {
        let btn = ASAuthorizationAppleIDButton()
        return btn
    }()
    
    
    // 发起授权请求
    func authorizationAppleID() {
//        let provider = ASAuthorizationAppleIDProvider()
//        let request = provider.createRequest()
    }
    
}

@available(iOS 13.0, *)
extension SignWithApple: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}




