//
//  CategoryViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageViewWithMask!
    
    public func setData(_ data: CategoryModel) {
        if Locale.current.languageCode == "ar" {
            self.titleLabel.text = data.nameAR ?? (data.name ?? "")
        } else {
            self.titleLabel.text = data.name ?? ""
        }
		
		if let imagePath = data.image, imagePath.length > 0 {
			self.imageView.loadImage(imagePath,
									 placeholderImage: nil,
									 showActivityIndicatorView: true)
		}		
    }
}
