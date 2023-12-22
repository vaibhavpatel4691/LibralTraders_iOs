//
//  TouchId.swift
//  Opencart
//
//  Created by kunal on 04/08/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchID {
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    var context = LAContext()
    var policy: LAPolicy?
    var view: UIViewController
    
    var supportedType: String {
        return context.biometricType == .touchID ? "TouchID".localized : "FaceID".localized
    }
    var isSupportedTouchID: Bool {
        var err: NSError?
        guard let policy = policy,
              context.canEvaluatePolicy(policy, error: &err) else {
            return false
        }
        return true
    }
    
    init(view: UIViewController) {
        self.view = view
        if Defaults.touchFlag == nil{
            Defaults.touchFlag = "0"
        }
    }
    
    
    func checkUserAuthentication(taskCallback: @escaping (Bool) -> Void) {
        policy = .deviceOwnerAuthentication
        print(context.biometryType)
        
        if isSupportedTouchID {
            applyLocalAuthentication() {
                taskCallback($0)
            }
            
        } else {
            self.showAlert(title: "error".localized, message: supportedType + "maynotbeconfigured".localized ) {
                taskCallback($0)
            }
        }
    }
    
    
    fileprivate func applyLocalAuthentication(taskCallback: @escaping (Bool) -> Void) {
        
        context.evaluatePolicy(policy!, localizedReason: kMsgShowReason) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    taskCallback(true)
                } else {
                    guard let error = error else {
                        self.showAlert(
                            title: "error".localized,
                            message: "erroroccured".localized) {
                            taskCallback($0)
                        }
                        return
                    }
                    debugPrint(error)
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.showAlert(title: "error".localized,
                                       message: "therewasaproblemverifyingyouridentity".localized) {
                            taskCallback($0)
                        }
                    case LAError.userCancel:
                        self.showAlert(title: "error".localized,
                                       message: "authenticationwascanceledbyuser".localized) {
                            taskCallback($0)
                        }
                    default:
                        self.showAlert(title: "error".localized,
                                       message: self.supportedType + "maynotbeconfigured".localized) { _ in }
                    }
                }
            }
        }
    }

    fileprivate func showAlert(title: String,
                               message: String,
                               option: UIAlertAction? = nil,
                               callBack: @escaping ((Bool) ->Void)) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Ok".localized,
                style: .default,
                handler: { _ in
                    callBack(false)
                })
        )
        if let option = option {
            alert.addAction(option)
        }
        view.present(alert, animated: true, completion: nil)
    }
    
    func askForLocalAuthentication(message: String, callBack: @escaping ((Bool) -> Void)) {
        let cancelBtn = UIAlertAction(title: "No".localized,
                                      style: .destructive) { _ in
            callBack(false)
        }
        showAlert(title: "alert".localized,
                  message: message + supportedType + " ?",
                  option: cancelBtn) {_ in
            callBack(true)
        }
    }
}

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .none
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
}
