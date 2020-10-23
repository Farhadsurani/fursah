//
//  MerchantPinCodeViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import SwiftyCodeView
import FacebookCore

class MerchantPinCodeViewController: BaseViewController {
    @IBOutlet weak var codeView: SwiftyCodeView!
    @IBOutlet weak var bannnerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    @IBOutlet weak var savingLabel: UILabel!
    @IBOutlet weak var rulesOfUseButton: UIButton!
    
    var voucherDetails: VoucherModel?
    var branchId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.codeView.semanticContentAttribute = .forceLeftToRight
        
        self.setLocalizeUI()
        self.setData()
        
        self.logInitiateCheckoutEvent(contentData: self.voucherDetails?.name ?? "", contentId: "", contentType: "product_details", numItems: 1, paymentInfoAvailable: true, currency: "OMR", totalPrice: Double(self.voucherDetails?.saving ?? "0") ?? 0.0)
    }
    
    private func setData() {
        if let data = self.voucherDetails {
            if Locale.current.languageCode == "ar" {
                self.titleLabel.text = data.nameAR ?? (data.name ?? "-")
            } else {
                self.titleLabel.text = data.name
            }
            
            if let dateTime = data.validDate {
                let date = Utility.getFormattedDateFromString(dateTime, inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM yyyy")
                self.expiresLabel.text = "Valid Until %@".localized(date ?? "-")
            }
            
            self.savingLabel.text = "OMR %@".localized(data.saving ?? "0")
            self.bannnerImageView.loadImage(data.image, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    private func setLocalizeUI() {
        let text = "Rules of Use".localized
		self.rulesOfUseButton.setTitle(text, for: .normal)
        
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 15),
//            .foregroundColor: AppColors.redColor,
//            .underlineStyle: NSUnderlineStyle.single.rawValue]
//
//        let attributeString = NSMutableAttributedString(string: text, attributes: attributes)
//
//        self.rulesOfUseButton.setAttributedTitle(attributeString, for: .normal)
		
    }
    
    private func logInitiateCheckoutEvent(contentData : String, contentId : String, contentType : String, numItems : Int, paymentInfoAvailable : Bool, currency : String, totalPrice : Double) {
        let params : AppEvent.ParametersDictionary = [
            .content : contentData,
            .contentId : contentId,
            .contentType : contentType,
            .itemCount : NSNumber(value:numItems),
            .paymentInfoAvailable : NSNumber(value: paymentInfoAvailable ? 1 : 0),
            .currency : currency
        ]
        let event = AppEvent(name: .initiatedCheckout, parameters: params, valueToSum: totalPrice)
        AppEventsLogger.log(event)
    }
    
    @IBAction func onBtnRedeem(_ sender: UIButton) {
		if AppStateManager.shared.isUserLoggedIn() {
			if self.codeView.code.length >= 4 {
				self.redeemVoucher()
			} else {
				Utility.showMessageAlert(message: "pin_code_not_valid".localized)
			}
		} else {
			Constants.APP_DELEGATE.showLoginViewController()
		}
    }
    
    @IBAction func onBtnTermsCondition() {
        self.showTermsConditions()
    }
    
    // MARK: - Web API Methods
    
    private func redeemVoucher() {
        Utility.showLoader()
        let params: [String: Any] = [
            "offer_id": self.voucherDetails?.id ?? "",
            "user_id": AppStateManager.shared.getUserId() ?? "",
            "merchant_code": self.codeView.code,
            "branch_id": self.branchId ?? ""
        ]
        APIManager.sharedInstance.merchant.redeemVoucher(params: params, success: { (response) in
            Utility.hideLoader()
			if let transactionId = response["transaction_id"] as? String {
				self.showSuccessPopup(transactionId)
                let amount = Double(self.voucherDetails?.saving ?? "0")
                let _ = AppEvent.purchased(amount: amount ?? 0.0, currency: "OMR", extraParameters: [:])
			} else {
				Utility.showErrorAlert(message: "Failed to generate transaction number".localized)
			}
        }) { (error) in
            Utility.hideLoader()
            Utility.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    
    private func showTermsConditions() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionsViewController") as! TermsConditionsViewController
		controller.title = "Rules of Use".localized
        if Locale.current.languageCode == "ar" {
            controller.termsCoditions = self.voucherDetails?.termsConditionsAR ?? ""
        } else {
            controller.termsCoditions = self.voucherDetails?.termsConditions ?? ""
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
	private func showSuccessPopup(_ transactionId: String?) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SuccessPopupViewController") as! SuccessPopupViewController
        controller.delegate = self
		controller.transactionId = transactionId
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension MerchantPinCodeViewController: SuccessPopupDelegate {
    func didClosePopup() {
        self.navigationController?.popViewController(animated: true)
    }
}
