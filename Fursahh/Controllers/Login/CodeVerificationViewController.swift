//
//  CodeVerificationViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import SwiftyCodeView

enum CodeVerificationTypes {
    case register
    case login
    case forgotPassword
}

class CodeVerificationViewController: BaseViewController {
    @IBOutlet weak var codeView: SwiftyCodeView!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    var type: CodeVerificationTypes = .register
    var emailAddress: String?
    var userDetails: UserModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.type == .login {
            self.sendEmailVerificationCode()
        }
    }
    
    @IBAction func onBtnResendCode(_ sender: UIButton) {
        self.sendEmailVerificationCode()
    }
    
    @IBAction func onBtnContinue(_ sender: UIButton) {
        guard codeView.code.count == 4 else {
            return
        }
        
        self.VerifyCode()
    }
    
    // MARK: - Web API Methods
    
    private func sendEmailVerificationCode() {
        Utility.showLoader()
        let params: [String: Any] = [
            "email": self.emailAddress ?? ""
        ]
        APIManager.sharedInstance.user.emailVerification(params: params, success: { (success) in
            Utility.hideLoader()
            print("Code has been sent to your email address")
        }) { (error) in
            Utility.hideLoader()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func VerifyCode() {
        Utility.showLoader()
        let params: [String: Any] = [
            "email": self.emailAddress ?? "",
            "otp": self.codeView.code
        ]
        APIManager.sharedInstance.user.verifyCode(params: params, success: { (success) in
            Utility.hideLoader()
            if self.type == .forgotPassword {
                self.showNewPassword()
            } else {
                if let user = self.userDetails {
                    user.emailVerification = "1"
                    AppStateManager.shared.saveUserDetails(user)
                    Constants.APP_DELEGATE.loadHomeViewController()
                }
            }            
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }

    // MARK: - Navigation
    
    private func showNewPassword() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordViewController")
            as! NewPasswordViewController
        
        controller.emailAddress = self.emailAddress
        controller.verificationCode = self.codeView.code
        
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .push(direction: .left)
        
        self.present(controller, animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension CodeVerificationViewController: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) {
        print(code)
    }
}
