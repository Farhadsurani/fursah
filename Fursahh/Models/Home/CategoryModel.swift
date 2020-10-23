//
//  CategoryModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoryModel: NSObject, Mappable {
    var id: String?    
    var image: String?
    var name: String?
    var nameAR: String?

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["category_id"]
        name <- map["name"]
        nameAR <- map["ar_name"]
        image <- map["image"]
    }
}
