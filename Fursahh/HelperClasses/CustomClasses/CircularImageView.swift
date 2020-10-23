//
//  CircularImageView.swift
//  SalamSquare
//
//  Created by Akber Sayni on 14/06/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

@IBDesignable
class CircularImageView: UIImageView {
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        makeCircularImage()
    }
    
    // drawRect will not work on UIImageView
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCircularImage()
    }
    
    func makeCircularImage() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
