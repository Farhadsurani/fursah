//
//  NewPasswordViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 25/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class NewPasswordViewController: BaseViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var emailAddress: String?
    var verificationCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUI()
    }
    
    private func updateUI() {
        self.passwordTextField.addPaddingRight(8.0)
        self.passwordTextField.addPaddingLeftIcon(UIImage(named: "icon_password")!, padding: 24.0)
        
        self.confirmPasswordTextField.addPaddingRight(8.0)
        self.confirmPasswordTextField.addPaddingLeftIcon(UIImage(named: "icon_password")!, padding: 24.0)
    }
    
    @IBAction func onBtnSubmit(_ sender: UIButton) {
        guard !(self.passwordTextField.trimmedText!.isEmpty)
            && !(self.confirmPasswordTextField.trimmedText!.isEmpty) else {
                Utility.showErrorAlert(message: "required_information_not_provided".localized)
                return
        }
        
        guard self.passwordTextField.hasValidPassword else {
            Utility.showErrorAlert(message: "password_not_valid".localized)
            return
        }

        guard (self.passwordTextField.text?.elementsEqual(self.confirmPasswordTextField.text!))! else {
            Utility.showErrorAlert(message: "password_not_match".localized)
            return
        }
        
        self.setNewPassword()
    }
    
    // MARK: - Web API Methods
    
    private func setNewPassword() {
        Utility.showLoader()
        let params: [String: Any] = [
            "email": self.emailAddress ?? "",
            "code": self.verificationCode ?? "",
            "new_password": self.passwordTextField.text ?? "",
        ]
        APIManager.sharedInstance.user.newPassword(params: params, success: { (success) in
            Utility.hideLoader()
            Utility.showMessageAlert(message: "password_created_success".localized, closure: { (action) in
                Constants.APP_DELEGATE.loadLoginViewController()
            })
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
