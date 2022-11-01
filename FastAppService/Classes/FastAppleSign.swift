//
//  FastAppleSign.swift
//  FastAppService
//
//  Created by pan zhang on 2022/7/15.
//
//  AppleID 登录

import Foundation
import AuthenticationServices

public typealias SignResultCallback = ((AppleAuthInfo?, Error?, String?)->())

public struct AppleAuthInfo {
    let userId: String
    let fullName: String?
    let email: String?
    let authorizationCode: String?
    let idefToken: String?
    let realUserStatus: ASUserDetectionStatus
    
    func debugPrint() {
        Swift.debugPrint("""
             userId : \(userId)
             fullName : \(fullName ?? "nil")
             email : \(email ?? "nil")
             authorizationCode : \(authorizationCode ?? "nil")
             idefToken : \(idefToken ?? "nil")
             realUserStatus : \(realUserStatus)
        """)
    }
}

@available(iOS 13.0, *)
open class FastAppleSign: NSObject {
    public static var shared: FastAppleSign = {
        let sha = FastAppleSign()
        return sha
    }()
    private override init() {}
    private var controller: ASAuthorizationController? = nil
    
    public var resultCallback: SignResultCallback? = nil
    
    public lazy var signButton:ASAuthorizationAppleIDButton? = {
        let btn = ASAuthorizationAppleIDButton()
        btn.addTarget(self, action: #selector(signButtonTouched), for: .touchUpInside)
        return btn
    }()
    
    @objc func signButtonTouched() {
        debugPrint("func signButtonTouched")
        self.authorizationAppleID()
    }
    
    // 发起授权请求
    func authorizationAppleID() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        var requests: [ASAuthorizationRequest] = []
        requests.append(request)
        
        let controller = ASAuthorizationController.init(authorizationRequests: requests)
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        self.controller = controller
    }
}

@available(iOS 13.0, *)
extension FastAppleSign: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // 授权失败
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint("authorizationController complet error: \(error.localizedDescription)")
        var errMsg = "授权失败"
        if let err = error as? ASAuthorizationError {
            switch err.code {
            case .canceled:
                debugPrint("用户取消了授权请求")
                errMsg = "您取消了授权"
                break
            case .unknown:
                debugPrint("授权请求失败未知原因")
                break
            case .invalidResponse:
                debugPrint("授权请求响应无效")
                break
            case .notHandled:
                debugPrint("未能处理授权请求")
                errMsg = "未能处理授权请求"
                break
            case .failed:
                debugPrint("授权请求失败")
                break
            case .notInteractive:
                debugPrint("iOS 15 notInteractive")
                break
            }
        }
        
        if let rbc = self.resultCallback {
            rbc(nil, error, errMsg)
        }
    }
    
    // 授权成功
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            debugPrint("sign authorization successed ")
            // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
            let userId = credential.user
            
            // 苹果用户信息 如果授权过，可能无法再次获取该信息
            var fullName: String? = nil
            if let fn = credential.fullName {
                let pf = PersonNameComponentsFormatter()
                fullName = pf.string(from: fn)
            }
            let email = credential.email
            
            // 服务器验证需要使用的参数
            var authorizationCode:String? = nil
            if let codeData = credential.authorizationCode {
                authorizationCode = String.init(data: codeData, encoding: .utf8)
            }
            
            var idefToken: String? = nil
            if let tokenData = credential.identityToken {
                idefToken = String.init(data: tokenData, encoding: .utf8)
            }
            
            // 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
            let realStatus = credential.realUserStatus
            
            let authInfo: AppleAuthInfo = AppleAuthInfo.init(
                userId: userId,
                fullName: fullName,
                email: email,
                authorizationCode: authorizationCode,
                idefToken: idefToken,
                realUserStatus: realStatus
            )
            
            authInfo.debugPrint()
            
            if let rcb = self.resultCallback {
                rcb(authInfo, nil, nil)
            }
        } else {
            debugPrint("sign authorization successed but not credential")
        }
    }
    
    // ASAuthorizationController 在哪个 window 上显示。
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let w = UIWindow.fe.currentWindow {
            return w
        }
        return UIWindow()
    }
}

@available(iOS 13.0, *)
extension FastAppleSign: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}




