//
//  RTLCollectionViewFlowLayout.swift
//  Fursahh
//
//  Created by Akber Sayni on 21/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class RTLCollectionViewFlowLayout: UICollectionViewFlowLayout {    
    
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }

}
