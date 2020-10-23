//
//  SettingsViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.tableFooterView = UIView()
        }
    }
    
    var items = ["Notifications".localized, "Terms & Conditions".localized, "Contact Us".localized, "Share the App".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if AppStateManager.shared.isUserLoggedIn() {
			// Update setting items
			items = ["Notifications".localized, "Change Password".localized, "Redemption History".localized, "Terms & Conditions".localized, "Contact Us".localized, "Share the App".localized, "Logout".localized]
		}
    }
    
    private func showLogoutPopup() {
        let alert = UIAlertController(title: "Confirmation".localized, message: "logout_confirmation_message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .default, handler: { (action) in
            AppStateManager.shared.removeUserDetails()
            Constants.APP_DELEGATE.loadLoginViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showAppSharingActivity() {
        if let appURL = NSURL(string: "https://apps.apple.com/us/app/fursahh/id1478949351?ls=1") {
            let text = "Hey There! I am using Fursahh and though you'd be interested in checking out amazing offers & discounts across Oman. Download Fursahh\n\n"
            let objectsToShare: [Any] = [text, appURL]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UI_USER_INTERFACE_IDIOM() == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    private func showTermsConditions() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionsViewController") as! TermsConditionsViewController        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showChangePassword() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController")
            as! ChangePasswordViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showRedemptionHistory() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "RedemptionHistoryViewController")
            as! RedemptionHistoryViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
	
	private func showContactUs() {
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController")
			as! ContactUsViewController
		
		self.navigationController?.pushViewController(controller, animated: true)
	}
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        var identifier: String!
        
        if item == "Notifications".localized {
            identifier = "SettingsToggleCellIdentifier"
        } else {
            identifier = "SettingsCellIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SettingsViewCell
        cell.titleLabel.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.items[indexPath.row]
        switch item {
        case "Change Password".localized:
            self.showChangePassword()
            break
        case "Redemption History".localized:
            self.showRedemptionHistory()
            break
        case "Terms & Conditions".localized:
            self.showTermsConditions()
            break
		case "Contact Us".localized:
			self.showContactUs()
			break
        case "Share the App".localized:
            self.showAppSharingActivity()
            break
        case "Logout".localized:
            self.showLogoutPopup()
            break
        default:
            break
        }
    }
}
