//
//  TermsConditionsViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class TermsConditionsViewController: BaseViewController {
    @IBOutlet weak var textView: UITextView!
    var termsCoditions: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		if let text = self.termsCoditions {
			self.textView.text = text
		} else {
			self.loadTermsAndConditions()
		}
    }
	
	
	private func loadTermsAndConditions() {
		let filename = Locale.current.languageCode == "ar" ? "terms_and_condition_ar" : "terms_and_conditions"
		if let url = Bundle.main.url(forResource:filename, withExtension: "rtf") {
			do {
				let data = try Data(contentsOf:url)
				let attibutedString = try NSAttributedString(data: data, documentAttributes: nil)
				let fullText = attibutedString.string
				self.textView.text = fullText
			} catch {
				print(error)
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
