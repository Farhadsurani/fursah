//
//  UIImageViewWithMask.swift
//  Fursahh
//
//  Created by Akber Sayni on 05/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageViewWithMask: UIImageView {
    var maskImageView = UIImageView()
    
    @IBInspectable
    var maskImage: UIImage? {
        didSet {
            maskImageView.image = maskImage
            maskImageView.frame = bounds
            mask = maskImageView
        }
    }    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
