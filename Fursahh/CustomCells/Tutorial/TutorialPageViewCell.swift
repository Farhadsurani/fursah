//
//  TutorialPageViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 13/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class TutorialPageViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    
    func setData(_ data: TutorialPageModel) {
        self.textLabel.text = data.text
        self.imageView.image = UIImage(named: data.image!)
    }
}
