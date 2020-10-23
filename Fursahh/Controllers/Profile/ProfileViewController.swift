//
//  ProfileViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var savingLabel: UILabel!
    @IBOutlet weak var redemptionHistoryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setLocalizeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()
        self.getSavingDetails()
    }
    
    private func setLocalizeUI() {
        let text = "View redemptions history".localized
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: text, attributes: attributes)
        
        self.redemptionHistoryButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    private func setData() {
        if let data = AppStateManager.shared.getUserDetails() {
            self.emailLabel.text = data.email
            self.usernameLabel.text = data.name
            if let imagePath = data.profilePicture {
                self.profileImageView.loadImage(imagePath, placeholderImage: UIImage(named: "icon_user_placeholder"), showActivityIndicatorView: true)
            }
        }
    }
    
    private func setSavingData(_ amount: String) {
        //self.savingLabel.text = String(format: "OMR %@", amount)
        self.savingLabel.text = "OMR %@".localized(amount)
    }
    
    @IBAction func onBtnEditProfile(_ sender: AnyObject) {
        self.showEditProfile()        
    }
    
    @IBAction func onBtnRedemptionHistory(_ sender: AnyObject) {
        self.showRedemptionHistory()        
    }
    
    // MARK: - Web API Methods
    
    private func getSavingDetails() {
        Utility.showLoader()
        let params: [String: Any] = [
            "user_id": AppStateManager.shared.getUserId() ?? ""
        ]
        APIManager.sharedInstance.user.getSavingDetails(params: params, success: { (response) in
            Utility.hideLoader()
            if let totalSavedAmount = response["total_amount_saved"] as? String {
                self.setSavingData(totalSavedAmount)
            }
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    
    private func showEditProfile() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")
            as! EditProfileViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showRedemptionHistory() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RedemptionHistoryViewController")
            as! RedemptionHistoryViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
