//
//  EditProfileViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import DropDown
import ALCameraViewController

class EditProfileViewController: BaseViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var ageRangeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    
    private var locationDropDown: DropDown!
    private var ageRangesDropDown: DropDown!

    var arrLocations = Array<String>()
    var arrAgeRanges = Array<String>()

    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUI()
        
        self.setPhoneTextField()
        self.loadLocationsData()
        self.loadAgeRangesData()

        self.locationDropDown = self.setDropDown(locationTextField, dataSource: self.arrLocations)
        self.ageRangesDropDown = self.setDropDown(ageRangeTextField, dataSource: self.arrAgeRanges)

        self.setData()
    }
    
    private func updateUI() {
        self.usernameTextField.addPaddingLeft(16.0)
        self.emailTextField.addPaddingLeft(16.0)
        self.phoneTextField.addPaddingLeft(16.0)
        self.ageRangeTextField.addPaddingLeft(16.0)
        self.locationTextField.addPaddingLeft(16.0)
        self.nationalityTextField.addPaddingLeft(16.0)

        self.ageRangeTextField.addPaddingRightIcon(UIImage(named: "icon_dropdown")!, padding: 16.0)
        self.locationTextField.addPaddingRightIcon(UIImage(named: "icon_dropdown")!, padding: 16.0)
        self.nationalityTextField.addPaddingRightIcon(UIImage(named: "icon_dropdown")!, padding: 16.0)
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

    private func setData() {
        if let user = AppStateManager.shared.getUserDetails() {
            self.usernameTextField.text = user.name
            self.emailTextField.text = user.email
            self.phoneTextField.text = user.phone
            self.ageRangeTextField.text = user.ageRange
            self.locationTextField.text = user.location
            self.nationalityTextField.text = user.nationality
            
            if let imagePath = user.profilePicture {
                self.profileImageView.loadImage(imagePath, placeholderImage: UIImage(named: "icon_user_placeholder"))
            }
        }
    }
    
    private func setPhoneTextField() {
        self.phoneTextField.delegate = self
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
    
    private func validateFields() -> Bool {
        guard !(self.usernameTextField.trimmedText!.isEmpty)
            && !(self.emailTextField.trimmedText!.isEmpty)
            else {
                Utility.showErrorAlert(message: "required_information_not_provided".localized)
                return false
        }
        
        guard self.emailTextField.hasValidEmail else {
            Utility.showErrorAlert(message: "email_not_valid".localized)
            return false
        }
        
        return true
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

    private func showImagePicker(_ sender: AnyObject) {
        let croppingParams = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: .zero)
        
        let imagePicker = CameraViewController.imagePickerViewController(croppingParameters: croppingParams) { [weak self] image, asset in
            // Do something with your image here.
            // If cropping is enabled this image will be the cropped version
            self?.dismiss(animated: true, completion: {
                if let image = image {
                    self?.profileImage = image
                    self?.profileImageView.image = image
                }
            })
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onBtnAddPhoto(_ sender: AnyObject) {
        self.showImagePicker(sender)
    }
    
    @IBAction func onBtnSubmit(_ sender: UIButton) {
        if self.validateFields() {
            self.updateProfile()
        }
    }
    
    // MARK: - Web API Methods
    
    private func updateProfile() {
        Utility.showLoader()
        
        let queryParams = [
            "user_id": AppStateManager.shared.getUserId() ?? ""
        ]
        
        var params: [String: Any] = [
            "name": self.usernameTextField.text ?? "",
            "username": self.usernameTextField.text ?? "",
            "phone": self.phoneTextField.text ?? "",
            "email": self.emailTextField.text ?? "",
            "age": self.ageRangeTextField.text ?? "",
            "city": self.locationTextField.text ?? "",
            "nationality": self.nationalityTextField.text ?? ""
        ]
        
        // Add profile image
        if let image = self.profileImage {
            let data = image.jpegData(compressionQuality: 0.5)
            params["profile_pic"] = data
        }

        APIManager.sharedInstance.user.updateUserProfile(params: params, queryParams: queryParams, success: { (response) in
            Utility.hideLoader()
            if let user = UserModel(JSON: response as! [String: Any]) {
                AppStateManager.shared.saveUserDetails(user)
                Utility.showMessageAlert(message: "update_user_profile_success".localized, closure: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                Utility.showErrorAlert(message: "update_user_profile_failed".localized)
            }
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

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.locationTextField {
            self.locationDropDown.show()
            return false
        } else if textField == self.ageRangeTextField {
            self.ageRangesDropDown.show()
            return false
        }  else if textField == self.nationalityTextField {
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
