//
//  VoucherModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 25/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class VoucherModel: NSObject, Mappable {
    var id: String?
    var name: String?
    var nameAR: String?
    var image: String?
    var type: String?
    var typeAR: String?
    var count: String?
    var saving: String?
    var isRedeemed: String?
    var validDate: String?
    var merchantId: String?
    var isLimited: String?
    var termsConditions: String?
    var termsConditionsAR: String?
    var isValid: Int = 0

    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["offer_id"]
        name <- map["name"]
        nameAR <- map["ar_name"]
        image <- map["image"]
        type <- map["offer_type"]
        typeAR <- map["ar_offer_type"]
        count <- map["offer_count"]
        isValid <- map["is_valid"]
        isRedeemed <- map["is_redeemed"]
        saving <- map["est_saved_money"]
        merchantId <- map["merchant_id"]
        isLimited <- map["is_limited"]
        termsConditions <- map["terms"]
        termsConditionsAR <- map["ar_terms"]
        validDate <- map["offer_valid_date"]
    }
}
