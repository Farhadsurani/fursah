//
//  LoginViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 06/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
	@IBOutlet weak var crossButton: UIButton!
	@IBOutlet weak var skipButton: UIButton!
	
	var isShowCrossButton: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateUI()
		self.skipButton.setTitle("Skip".localized, for: .normal)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if self.isShowCrossButton {
			self.crossButton.isHidden = false
			self.skipButton.isHidden = true
		} else {
			self.crossButton.isHidden = true
			self.skipButton.isHidden = false
		}
	}
    
    private func updateUI() {
        self.emailTextField.addPaddingRight(8.0)
        self.emailTextField.addPaddingLeftIcon(UIImage(named: "icon_email")!, padding: 24.0)
        
        self.passwordTextField.addPaddingRight(8.0)
        self.passwordTextField.addPaddingLeftIcon(UIImage(named: "icon_password")!, padding: 24.0)
    }
    
    private func validateFields() -> Bool {
        guard !(self.emailTextField.trimmedText!.isEmpty)
        && !(self.passwordTextField.trimmedText!.isEmpty) else {
            Utility.showErrorAlert(message: "required_information_not_provided".localized)
            return false
        }
        
        guard self.emailTextField.hasValidEmail else {
            Utility.showErrorAlert(message: "email_not_valid".localized)
            return false
        }
        
        return true
    }

    @IBAction func onBtnForgotPassword(_ sender: UIButton) {
        self.showForgotPassword()
    }
    
    @IBAction func onBtnSignup(_ sender: UIButton) {
        self.showSignupController()
    }
    
    @IBAction func onBtnLogin(_ sender: UIButton) {
        guard self.validateFields() else {
            return
        }
        
        self.loginUser()
    }
    
    @IBAction func onBtnFacebookLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print(accessToken)
                print(grantedPermissions)
                print(declinedPermissions)
                
                self.loginWithFacebook(accessToken.authenticationToken)
            }
        }
    }
    
    @IBAction func onBtnInstagramLogin(_ sender: UIButton) {
        self.showInstagramLogin()
    }
	
	@IBAction func onBtnCross(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onBtnSkip(_ sender: UIButton) {
		// Show home view controller
		Constants.APP_DELEGATE.loadHomeViewController()
	}
    
    // MARK: - Web API Methods
    
    private func loginUser() {
        Utility.showLoader()
        let params: [String: Any] = [
            "email": self.emailTextField.text ?? "",
            "password": self.passwordTextField.text ?? "",
        ]
        APIManager.sharedInstance.user.loginUser(params: params, success: { (response) in
            Utility.hideLoader()
            if let user = UserModel(JSON: response as! [String: Any]) {
                if let verified = user.emailVerification, verified.elementsEqual("1") {
                    // Show home view controller
                    AppStateManager.shared.saveUserDetails(user)
                    Constants.APP_DELEGATE.loadHomeViewController()
                } else {
                    // Show OTP code view controller
                    self.showCodeVerificaton(user)
                }
            }
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func loginWithFacebook(_ token: String) {
        Utility.showLoader()
        let params: [String: Any] = [
            "access_token": token,
        ]
        APIManager.sharedInstance.user.loginWithFacebook(params: params, success: { (response) in
            Utility.hideLoader()
            if let user = UserModel(JSON: response as! [String: Any]) {
                if let verified = user.emailVerification, verified.elementsEqual("1") {
                    // Show home view controller
                    AppStateManager.shared.saveUserDetails(user)
                    Constants.APP_DELEGATE.loadHomeViewController()
                } else {
                    // Show OTP code view controller
                    self.showCodeVerificaton(user)
                }
            }
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func loginWithInstagram(_ token: String) {
        Utility.showLoader()
        let params: [String: Any] = [
            "access_token": token,
        ]
        APIManager.sharedInstance.user.loginWithInstagram(params: params, success: { (response) in
            Utility.hideLoader()
            if let user = UserModel(JSON: response as! [String: Any]) {
                if let verified = user.emailVerification, verified.elementsEqual("1") {
                    // Show home view controller
                    AppStateManager.shared.saveUserDetails(user)
                    Constants.APP_DELEGATE.loadHomeViewController()
                } else {
                    // Show OTP code view controller
                    self.showCodeVerificaton(user)
                }
            }
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
	
    // MARK: - Navigation
    
    private func showSignupController() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController")
            as! SignupViewController
        
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .push(direction: .left)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showForgotPassword() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
            as! ForgotPasswordViewController
        
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .push(direction: .left)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showCodeVerificaton(_ user: UserModel) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerificationViewController")
            as! CodeVerificationViewController
        
        controller.type = .login
        controller.userDetails = user
        controller.emailAddress = user.email
        
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .push(direction: .left)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showInstagramLogin() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "InstagramLoginViewController")
            as! InstagramLoginViewController
        
        controller.delegate = self
        controller.hero.isEnabled = true
        controller.hero.modalAnimationType = .auto
        
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension LoginViewController: InstagramLoginDelegate {
    func didHandleAuthToken(_ token: String) {
        self.loginWithInstagram(token)
    }
}
