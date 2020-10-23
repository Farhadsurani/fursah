//
//  OfferRedeemedViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class OfferRedeemedViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var redeemedLabel: UILabel!
    @IBOutlet weak var savingLabel: UILabel!
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var merchantImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(_ data: RedeemedVoucherModel) {
        if let langCode = Locale.current.languageCode, langCode == "ar" {
            self.nameLabel.text = data.nameAR ?? data.name ?? "-"
            self.merchantLabel.text = data.merchantNameAR ?? data.merchantName ?? "-"
        } else {
            self.nameLabel.text = data.name
            self.merchantLabel.text = data.merchantName
            self.redeemedLabel.text = data.redeemedDate
        }
        
        self.savingLabel.text = "Estimated Savings OMR %@".localized(data.saving ?? "")
        if let dateTime = data.redeemedDate {
            self.redeemedLabel.text = Utility.getFormattedDateFromString(
                dateTime, inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM yyyy")
        }
    }
}
