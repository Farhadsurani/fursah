//
//  TutorialPageModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 13/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class TutorialPageModel: NSObject {
    var text: String?
    var image: String?

    init(_ text: String, image: String) {
        self.text = text
        self.image = image
    }
}
