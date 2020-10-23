//
//  ConfirmationPopupViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 13/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

protocol ConfirmationPopupDelegate {
	func didTapCancelButton()
    func didTapChangeOutletButton()
    func didTapContinueButton(_ voucher: VoucherModel?)
}

enum ConfirmationPopupType {
	case invalidOutlet
	case confirmOutlet
}

class ConfirmationPopupViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionLeftButton: UIButton!
    @IBOutlet weak var actionRightButton: UIButton!
    
    var delegate: ConfirmationPopupDelegate?
	var type: ConfirmationPopupType = .confirmOutlet
    
    var branch: BranchModel?
    var voucherDetails: VoucherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if Locale.current.languageCode == "ar" {
            self.titleLabel.text = self.branch?.nameAR ?? (branch?.name ?? "-")
        } else {
            self.titleLabel.text = self.branch?.name ?? "-"
        }
		
		self.setData()
    }
	
	private func setData() {
		if self.type == .invalidOutlet {
			self.messageLabel.text = "invalid_outlet_message".localized
			
			self.actionRightButton.setTitle("Cancel".localized, for: .normal)
			self.actionLeftButton.setTitle("Change Outlet".localized, for: .normal)
		} else {
			self.messageLabel.text = "confirm_outlet_message".localized
			
			self.actionRightButton.setTitle("Continue".localized, for: .normal)
			self.actionLeftButton.setTitle("Change Outlet".localized, for: .normal)
		}
	}
    
    private func delegateActionButton(_ button: UIButton) {
        guard self.delegate != nil else { return }
        
        if button == self.actionLeftButton {
            self.delegate?.didTapChangeOutletButton()
        } else {
			if self.type == .invalidOutlet {
				self.delegate?.didTapCancelButton()
			} else {
				self.delegate?.didTapContinueButton(self.voucherDetails)
			}
        }
    }
    
    @IBAction func onBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegateActionButton(sender)
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
