//
//  FastPassword.swift
//  FastAppService
//
//  Created by pan zhang on 2022/7/19.
//
// 特征密码（指纹，面纹登录）

import Foundation
import LocalAuthentication // 本地验证

let FastPasswordDataKey: String = "MgIbDioqoyWAnPf"
open class FastPassword {
    
    public static var shared: FastPassword = {
        let sha = FastPassword()
        return sha
    }()
    private init() {}
    
    public func localFingerAuthentication(autoAlert:Bool = false, completion: @escaping (Data?, Error?)->()) -> Bool{
        let context = LAContext()
        context.localizedCancelTitle = "Cancel".fastLocalized
        var error: NSError? = nil
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "验证已有指纹")
            { success, error in
                if success {
                    debugPrint("finger success")
                    completion(context.evaluatedPolicyDomainState, nil)
                } else if let err = error {
                    debugPrint("finger error: \(err.localizedDescription)")
                    completion(nil, err as Error)
                }
            }
        } else {
            return false
        }
        return true
    }
    
    public func startLocalAuthentication() -> Error? {
        var error: NSError? = nil
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if let state = context.evaluatedPolicyDomainState {
                UserDefaults.standard.set(state, forKey: FastPasswordDataKey)
                UserDefaults.standard.synchronize()
            } else {
                return NSError(domain: "开启指纹验证失败", code: 0) as Error
            }
        }
        
        return error as Error?
    }
    
    lazy var localAuthState: Data? = {
        return UserDefaults.standard.data(forKey: FastPasswordDataKey)
    }()
    
    lazy var localPasswordType: String = {
        if #available(iOS 11.0, *) {
            switch LAContext().biometryType {
            case .none:
                return "无"
            case .faceID:
                return "Face ID"
            case .touchID:
                return "Touch ID"
            }
        }
        
        return "Touch ID"
    }()
}

extension Error {
    func handlePassworError(autoAlert: Bool = false) -> String? {
        let nsErr = self as NSError
        let idType = FastPassword.shared.localPasswordType
        
        if let laCode = LAError.Code.init(rawValue: nsErr.code) {
            switch laCode {
            case .authenticationFailed:
                return "\(idType) 验证失败"
            default:
                return nsErr.localizedDescription
            }
        }
        
        switch nsErr.code {
        case 0:
            return "开启\(idType)验证失败"
        default:
            return nsErr.localizedDescription
        }
    }
}

