//
//  AttributeModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 18/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class AttributeModel: NSObject, Mappable {
    var id: String?
    var name: String?
    var type: String?
	var nameAR: String?
	
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["attributes"]
        type <- map["type"]
		nameAR <- map["ar_attributes"]
    }
}
