//
//  SearchMerchantViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 01/09/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class SearchMerchantViewCell: UITableViewCell {
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setData(_ data: MerchantModel) {
		self.nameLabel.text = data.name
		self.logoImageView.loadImage(data.logoImage, placeholderImage: nil, showActivityIndicatorView: true)
	}
}
