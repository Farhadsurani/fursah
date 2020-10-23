//
//  ForgotPasswordViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUI()
    }
    
    private func updateUI() {
        self.emailTextField.addPaddingRight(8.0)
        self.emailTextField.addPaddingLeftIcon(UIImage(named: "icon_email")!, padding: 24.0)
    }
    
    @IBAction func onBtnSubmit(_ sender: UIButton) {
        guard !(self.emailTextField.trimmedText!.isEmpty) else {
            Utility.showErrorAlert(message: "required_information_not_provided".localized)
            return
        }
        
		guard self.emailTextField.hasValidEmail else {
			Utility.showErrorAlert(message: "email_not_valid".localized)
			return
		}

        self.sendEmailVerificationCode()
    }
    
    // MARK: - Web API Methods
    
    private func sendEmailVerificationCode() {
        Utility.showLoader()
        let params: [String: Any] = [
            "email": self.emailTextField.text ?? ""
        ]
        APIManager.sharedInstance.user.emailVerification(params: params, success: { (success) in
            Utility.hideLoader()
            self.showCodeVerification()
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    
    private func showCodeVerification() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerificationViewController")
            as! CodeVerificationViewController
        
        controller.type = .forgotPassword
        controller.emailAddress = self.emailTextField.text
        
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

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
