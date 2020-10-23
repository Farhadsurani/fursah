//
//  ContactUsViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 13/09/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class ContactUsViewController: BaseViewController {
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var whatsappLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.logContactEvent()
    }
    
    private func logContactEvent() {
        FBSDKAppEvents.logEvent(FBSDKAppEventNameContact)
    }
	
	@IBAction func onBtnEmail(_ sender: UIButton) {
		let emailAddress = self.emailLabel.text!
		self.showMailComposer(emailAddress)
		
	}

	@IBAction func onBtnPhone(_ sender: UIButton) {
		let phoneNo = self.phoneLabel.text!
		self.showPhoneDialer(phoneNo)
	}

	@IBAction func onBtnWhatsapp(_ sender: UIButton) {
		let whatsapp = self.whatsappLabel.text!
		self.showWhatsApp(whatsapp)
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
