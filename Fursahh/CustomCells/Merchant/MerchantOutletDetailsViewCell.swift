//
//  MerchantOutletDetailsViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 17/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class MerchantOutletDetailsViewCell: UITableViewCell {
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }    
    
    public func setData(_ data: MerchantModel?, branch: BranchModel?) {
        if Locale.current.languageCode == "ar" {
            self.timingLabel.text = data?.timmingsAR ?? (data?.timmings ?? "-")
            self.phoneLabel.text = branch?.phoneNo ?? "-"
            self.instagramLabel.text = data?.instagram ?? "-"
            self.addressLabel.text = "%@ (%@ KM away)".localized(branch?.nameAR ?? branch?.name ?? "-", branch?.distance ?? "-")
        } else {
            self.timingLabel.text = data?.timmings ?? "-"
            self.instagramLabel.text = data?.instagram ?? "-"
            self.phoneLabel.text = branch?.phoneNo ?? "-"
            self.addressLabel.text = "%@ (%@ KM away)".localized(branch?.name ?? "-", branch?.distance ?? "-")
        }
    }
}
