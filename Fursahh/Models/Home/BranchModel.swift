//
//  BranchModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 27/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class BranchModel: NSObject, Mappable {
    var id: String?
    var name: String?
    var nameAR: String?
    var phoneNo: String?
    var distance: String?
    var latitude: String?
    var longitude: String?
    var location: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["branch_id"]
        name <- map["b_name"]
        nameAR <- map["ar_branch_name"]
        phoneNo <- map["branch_contact_no"]
        distance <- map["distance"]
        latitude <- map["lat"]
        longitude <- map["long"]
        location <- map["branch_location"]
    }
}
