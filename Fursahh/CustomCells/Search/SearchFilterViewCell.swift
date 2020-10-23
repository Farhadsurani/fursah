//
//  SearchFilterViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 18/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class SearchFilterViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(_ data: AttributeModel, selectedItems: [AttributeModel]) {
		if let langCode = Locale.current.languageCode, langCode == "ar" {
			self.titleLabel.text = data.nameAR ?? "-"
		} else {
			self.titleLabel.text = data.name ?? "-"
		}

        let results = selectedItems.filter { $0.id == data.id }
        self.checkboxButton.isSelected = !(results.isEmpty)
    }
}
