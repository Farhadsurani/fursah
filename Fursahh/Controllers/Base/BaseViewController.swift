//
//  BaseViewController.swift
//  SalamSquare
//
//  Created by Akber Sayni on 12/06/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import MessageUI
import BBBadgeBarButtonItem

class BaseViewController: UIViewController {
    
    var cartItem: BBBadgeBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let navController = self.navigationController, navController.viewControllers.count > 1 {
            self.addBackButton()
        }
    }
    
    private func addBackButton() {
        var backImage = UIImage(named: "icon_btn_back")
        
        if Locale.current.languageCode == "ar" {
            backImage = backImage?.imageFlippedForRightToLeftLayoutDirection()
        }
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
        button.setImage(backImage, for: .normal)
        button.addTarget(self, action: #selector(self.onBackButtonItem(_:)), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = item
    }
    
    func addTitleImage() {
        let image = UIImage(named: "logo_nav_title")
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 35))
        
        let imageView = UIImageView(frame: titleView.frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        titleView.addSubview(imageView)
        
        self.navigationItem.titleView = titleView
    }
    
    func showInstagramAccount(_ username: String) {
        var url = URL(string: "instagram://user?username=\(username)")!
        if !UIApplication.shared.canOpenURL(url) {
            url = URL(string: "https://instagram.com/\(username)")!
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showPhoneDialer(_ phone: String) {
        if let phoneURL = URL(string: "tel://\(phone)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                Utility.showMessageAlert(message: "call_option_not_available".localized)
            }
        }
    }
    
    func showYoutubeVideo(_ videoId: String) {
        var url = URL(string: "youtube://\(videoId)")!
        if !UIApplication.shared.canOpenURL(url) {
            url = URL(string: "http://www.youtube.com/watch?v=\(videoId)")!
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
	
	func showWhatsApp(_ whatsapp: String) {
		guard let whatsappURL = URL(string: whatsapp) else {
			Utility.showAlert(title: "Message", message: "Whatsapp number not valid")
			return
		}
		
		if UIApplication.shared.canOpenURL(whatsappURL) {
			UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
		} else {
			Utility.showAlert(title: "Message", message: "WhatsApp app not installed")
		}
	}

	
	func showMailComposer(_ emailAddress: String) {
		if MFMailComposeViewController.canSendMail() {
			let composer = MFMailComposeViewController()
			composer.mailComposeDelegate = self
			composer.setToRecipients([emailAddress])
			composer.setSubject("Fursahh app feedback")
			self.present(composer, animated: true, completion: nil)
		} else {
			Utility.showAlert(title: "Message", message: "Email client is not configured")
		}
	}
	
    @objc private func onBackButtonItem(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissViewController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
	
    // MARK: - Navigation
	
	func showOfflineViewController() {
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "OfflineViewController")
			as! OfflineViewController
		
		self.present(controller, animated: true, completion: nil)
	}
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension BaseViewController: MFMailComposeViewControllerDelegate {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		self.dismiss(animated: true, completion: nil)
	}
}
