//
//  SignupViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 06/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import DropDown
import FacebookCore
import FacebookLogin

class SignupViewController: BaseViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
	@IBOutlet weak var ageRangeTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var nationalityTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var confirmPasswordTextField: UITextField!
	@IBOutlet weak var signinButton: UIButton!

    private var locationDropDown: DropDown!
    private var ageRangesDropDown: DropDown!
    
    var arrLocations = Array<String>()
    var arrAgeRanges = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUI()
        self.setLocalizeUI()
        self.loadLocationsData()
        self.loadAgeRangesData()
        
        self.setPhoneTextField()
        self.locationDropDown = self.setDropDown(locationTextField, dataSource: self.arrLocations)
        self.ageRangesDropDown = self.setDropDown(ageRangeTextField, dataSource: self.arrAgeRanges)
    }
    
    private func updateUI() {
        self.usernameTextField.addPaddingRight(8.0)
        self.usernameTextField.addPaddingLeftIcon(UIImage(named: "icon_username")!, padding: 24.0)
        
        self.emailTextField.addPaddingRight(8.0)
        self.emailTextField.addPaddingLeftIcon(UIImage(named: "icon_email")!, padding: 24.0)
        
        self.phoneTextField.addPaddingRight(8.0)
        self.phoneTextField.addPaddingLeftIcon(UIImage(named: "icon_phone")!, padding: 24.0)
        
        self.ageRangeTextField.addPaddingRight(8.0)
        self.ageRangeTextField.addPaddingRightIcon(UIImage(named: "icon_dropdown")!, padding: 16.0)
        self.ageRangeTextField.addPaddingLeftIcon(UIImage(named: "icon_username")!, padding: 24.0)

        self.locationTextField.addPaddingRight(8.0)
        self.locationTextField.addPaddingRightIcon(UIImage(named: "icon_dropdown")!, padding: 16.0)
        self.locationTextField.addPaddingLeftIcon(UIImage(named: "icon_username")!, padding: 24.0)

        self.nationalityTextField.addPaddingRight(8.0)
        self.nationalityTextField.addPaddingRightIcon(UIImage(named: "icon_dropdown")!, padding: 16.0)
        self.nationalityTextField.addPaddingLeftIcon(UIImage(named: "icon_username")!, padding: 24.0)

        self.passwordTextField.addPaddingRight(8.0)
        self.passwordTextField.addPaddingLeftIcon(UIImage(named: "icon_password")!, padding: 24.0)

        self.confirmPasswordTextField.addPaddingRight(8.0)
        self.confirmPasswordTextField.addPaddingLeftIcon(UIImage(named: "icon_password")!, padding: 24.0)
    }
    
    private func setLocalizeUI() {
//        let text = "Signin".localized
//        
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 15),
//            .foregroundColor: AppColors.redColor,
//            .underlineStyle: NSUnderlineStyle.single.rawValue]
//        
//        let attributeString = NSMutableAttributedString(string: text, attributes: attributes)
//        
//        self.signinButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    private func loadLocationsData() {
        let filename = Locale.current.languageCode == "ar" ? "Locations-ar" : "Locations"
        
        let path = Bundle.main.path(forResource: filename, ofType: "plist")!
        if let data = NSDictionary(contentsOfFile: path) {
            self.arrLocations = data.object(forKey: "Locations") as! [String]
            self.arrLocations = arrLocations.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        }
    }
    
    private func loadAgeRangesData() {
        let filename = Locale.current.languageCode == "ar" ? "AgeRanges-ar" : "AgeRanges"
        
        let path = Bundle.main.path(forResource: filename, ofType: "plist")!
        if let data = NSDictionary(contentsOfFile: path) {
            self.arrAgeRanges = data.object(forKey: "Ranges") as! [String]
        }
    }

    private func setDropDown(_ textField: UITextField, dataSource: [String]) -> DropDown {
        textField.delegate = self
        
        let dropdown = DropDown()
        dropdown.anchorView = textField
        dropdown.dataSource = dataSource
        dropdown.bottomOffset = CGPoint(x: 0, y: (dropdown.anchorView?.plainView.bounds.height)!)
        dropdown.selectionAction = { (index: Int, item: String) in
            textField.text = item
        }
        
        return dropdown
    }
    
    private func setPhoneTextField() {
        self.phoneTextField.delegate = self
    }
    
    private func showCountryPicker(_ sender: UITextField) {
        let picker = MICountryPicker()
        picker.showCallingCodes = false
        picker.didSelectCountryClosure = { name, code in
            // Dismiss country picker
            self.dismiss(animated: true, completion: {
                sender.text = name
            })
        }
        
        self.present(BaseNavigationController(rootViewController: picker), animated: true, completion: nil)
    }
    
    private func getUserProfile() {
        struct MyProfileRequest: GraphRequestProtocol {
            struct Response: GraphResponseProtocol {
                init(rawResponse: Any?) {
                    // Decode JSON from rawResponse into other properties here.
                }
            }
            
            var graphPath = "/me"
            var parameters: [String : Any]? = ["fields": "id, name"]
            var accessToken = AccessToken.current
            var httpMethod: GraphRequestHTTPMethod = .GET
            var apiVersion: GraphAPIVersion = .defaultVersion
        }
        
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response)")
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    private func validateFields() -> Bool {
        guard !(self.usernameTextField.trimmedText!.isEmpty)
            && !(self.emailTextField.trimmedText!.isEmpty)
            && !(self.passwordTextField.trimmedText!.isEmpty)
            && !(self.confirmPasswordTextField.trimmedText!.isEmpty) else {
                Utility.showErrorAlert(message: "required_information_not_provided".localized)
                return false
        }
        
        guard self.emailTextField.hasValidEmail else {
            Utility.showErrorAlert(message: "email_not_valid".localized)
            return false
        }
        
        guard self.passwordTextField.hasValidPassword else {
            Utility.showErrorAlert(message: "password_not_valid".localized)
            return false
        }
        
        guard self.phoneTextField.text!.length >= 12 else {
            Utility.showErrorAlert(message: "phone_not_valid".localized)
            return false
        }
        
        guard (self.passwordTextField.text?.elementsEqual(self.confirmPasswordTextField.text!))! else {
            Utility.showErrorAlert(message: "password_not_match".localized)
            return false
        }
        
        return true
    }
    
    private func logCompleteRegistrationEvent(registrationMethod : String) {
        let params : AppEvent.ParametersDictionary = [.registrationMethod : registrationMethod]
        let event = AppEvent(name: .completedRegistration, parameters: params)
        AppEventsLogger.log(event)
    }
	
	// MARK: - IBAction Methods

    @IBAction func onBtnSignup(_ sender: UIButton) {
        guard self.validateFields() else {
            return
        }
        
        self.registerUser()
    }
    
    @IBAction func onBtnFacebook(_ sender: UIButton) {
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
                
                //self.getUserProfile()
                self.loginWithFacebook(accessToken.authenticationToken)
            }
        }
    }
    
    @IBAction func onBtnInstagramLogin(_ sender: UIButton) {
        self.showInstagramLogin()
    }
    
    // MARK: - Web API Methods
    
    private func registerUser() {
        Utility.showLoader()
        let params: [String: Any] = [
            "name": self.usernameTextField.text ?? "",
            "username": self.usernameTextField.text ?? "",
            "phone": self.phoneTextField.text ?? "",
            "email": self.emailTextField.text ?? "",
            "password": self.passwordTextField.text ?? "",
            "age": self.ageRangeTextField.text ?? "",
            "city": self.locationTextField.text ?? "",
            "nationality": self.nationalityTextField.text ?? ""
        ]
        APIManager.sharedInstance.user.registerUser(params: params, success: { (response) in
            Utility.hideLoader()
            self.logCompleteRegistrationEvent(registrationMethod: "email")
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
            self.logCompleteRegistrationEvent(registrationMethod: "facebook")
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
            self.logCompleteRegistrationEvent(registrationMethod: "instagram")
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
    
    private func showCodeVerificaton(_ user: UserModel) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CodeVerificationViewController")
            as! CodeVerificationViewController
        
        controller.type = .register
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

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.locationTextField {
            self.locationDropDown.show()
            return false
        } else if textField == self.ageRangeTextField {
            self.ageRangesDropDown.show()
            return false
        } else if textField == self.nationalityTextField {
            self.showCountryPicker(textField)
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneTextField {
            if let textRange = Range(range, in: textField.text!) {
                if let newString = textField.text?.replacingCharacters(in: textRange, with: string),
                    (newString.length > 12) {
                    return false
                }
            }
        }
        
        return true
    }
}

extension SignupViewController: InstagramLoginDelegate {
    func didHandleAuthToken(_ token: String) {
        self.loginWithInstagram(token)
    }
}
