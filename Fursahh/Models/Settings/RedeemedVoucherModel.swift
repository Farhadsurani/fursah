//
//  RedeemedVoucherModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 07/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class RedeemedVoucherModel: NSObject, Mappable {
    var name: String?
    var nameAR: String?
    var merchantName: String?
    var merchantNameAR: String?
    var saving: String?
    var redeemedDate: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        nameAR <- map["ar_name"]
        merchantName <- map["merchant_name"]
        merchantNameAR <- map["ar_merchant_name"]
        saving <- map["est_saved_money"]
        redeemedDate <- map["offer_redeemed_date"]
    }
}
