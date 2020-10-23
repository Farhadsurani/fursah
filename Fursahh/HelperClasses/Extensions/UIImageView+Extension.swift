//
//  UIImageView+Extension.swift
//  ProQ
//
//  Created by Akber Sayni on 25/03/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import AlamofireImage
import SDWebImage

extension UIImageView {
    func loadImage(_ imagePath: String?, placeholderImage: UIImage?, showActivityIndicatorView: Bool = false) {
        guard imagePath != nil else { return }
        
        let manager = SDWebImageManager.shared()
        manager.imageDownloader?.downloadTimeout = 120.0
        
        if let imageURL = URL(string: imagePath!) {
            self.sd_setIndicatorStyle(.gray)
            self.sd_setShowActivityIndicatorView(showActivityIndicatorView)
            self.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
        }
    }
}
