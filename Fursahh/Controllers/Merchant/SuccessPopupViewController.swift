//
//  SuccessPopupViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 14/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

protocol SuccessPopupDelegate {
    func didClosePopup()
}

class SuccessPopupViewController: BaseViewController {
	@IBOutlet weak var transactionTitleLabel: UILabel!
	@IBOutlet weak var transactionValueLabel: UILabel!
	
	var transactionId: String?
    var delegate: SuccessPopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.setData()
    }
	
	private func setData() {
		self.transactionTitleLabel.text = "Transaction Ref.".localized
		self.transactionValueLabel.text = self.transactionId ?? "-"
	}
    
    @IBAction func onBtnClose(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate?.didClosePopup()
            }
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
