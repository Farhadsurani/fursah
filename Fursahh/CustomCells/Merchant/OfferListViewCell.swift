//
//  OfferListViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class OfferListViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    @IBOutlet weak var offerCountLabel: UILabel!
    @IBOutlet weak var offerTypeLabel: UILabel!
    @IBOutlet weak var offerTyeImageView: UIImageView!
    @IBOutlet weak var offerCountStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setOfferTypeImage(_ type: String) {
        if type.contains("Buy") {
            self.offerTyeImageView.image = UIImage(named: "icon_buy_offer")
        } else if type.contains("Combo") {
            self.offerTyeImageView.image = UIImage(named: "icon_combo_offer")
        } else {
            self.offerTyeImageView.image = UIImage(named: "icon_discount_offer")
        }
    }
    
    private func setOfferTypeLabel(_ type: String) {
        if type.contains("Buy") {
            self.offerTypeLabel.text = "Buy 1 Get 1 Free".localized
        } else if type.contains("Combo") {
            self.offerTypeLabel.text = "Combo Offer".localized
        } else {
            self.offerTypeLabel.text = "Discount Offer".localized
        }
    }

    public func setData(_ data: VoucherModel) {
        self.setOfferTypeImage(data.type ?? "")
        self.setOfferTypeLabel(data.type ?? "")
        
        if Locale.current.languageCode == "ar" {
            self.nameLabel.text = data.nameAR ?? (data.name ?? "-")
        } else {
            self.nameLabel.text = data.name ?? "-"
        }

        self.offerCountLabel.text = data.count
        //self.expiresLabel.text = data.validDate
        if let dateTime = data.validDate {
            //self.expiresLabel.text = Utility.getFormattedDateFromString(dateTime, withFormat: "dd MMM yyyy")
            self.expiresLabel.text = Utility.getFormattedDateFromString(
                dateTime, inputFormat: "yyyy-MM-dd", outputFormat: "dd MMM yyyy")
        }
        
        // Show/hide offer count stack view
        if let isLimited = data.isLimited, isLimited.lowercased().contains("yes") {
            self.offerCountStackView.isHidden = false
        } else {
            self.offerCountStackView.isHidden = true
        }
    }
    
    public func setRedeemedData(_ data: VoucherModel) {
        self.setOfferTypeLabel(data.type ?? "")
        
        if Locale.current.languageCode == "ar" {
            self.nameLabel.text = data.nameAR ?? (data.name ?? "-")
        } else {
            self.nameLabel.text = data.name ?? "-"
        }
    }
}
