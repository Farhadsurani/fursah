//
//  MerchantListViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class MerchantListViewCell: UITableViewCell {
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.cardView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.bannerImageView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(_ data: MerchantModel) {
        if Locale.current.languageCode == "ar" {
            self.nameLabel.text = data.nameAR ?? (data.name ?? "-")
            self.categoryLabel.text = data.categoryAR ?? (data.category ?? "-")
        } else {
            self.nameLabel.text = data.name
            self.categoryLabel.text = data.category
        }
        
        self.logoImageView.loadImage(data.logoImage, placeholderImage: nil)
        
        // Add banner image
        if let bannerImage = data.bannerImage, bannerImage.length > 0 {
            self.bannerImageView.loadImage(bannerImage, placeholderImage: UIImage(named: "placehollder"))
        } else {
            if let images = data.bannerImages, images.count > 0 {
                self.bannerImageView.loadImage(images.first, placeholderImage: UIImage(named: "placehollder"))
            }
        }

        // Add branch data
        if let branch = data.branches?.first {
            if Locale.current.languageCode == "ar" {
                self.addressLabel.text = branch.nameAR ?? (branch.name ?? "-")
                self.distanceLabel.text = "%@ KM away".localized(branch.distance ?? "0")
            } else {
                self.addressLabel.text = branch.name ?? "-"
                self.distanceLabel.text = "%@ KM away".localized(branch.distance ?? "0")
            }
        }
    }
}
