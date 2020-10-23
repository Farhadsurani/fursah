//
//  MerchantLogoViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class MerchantLogoViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    public func setData(_ data: MerchantModel) {
        self.imageView.loadImage(data.logoImage, placeholderImage: nil, showActivityIndicatorView: true)
    }    
}
