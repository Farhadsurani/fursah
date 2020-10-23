//
//  MerchantModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 25/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class MerchantModel: NSObject, Mappable {
    var id: String?
    var name: String?
    var nameAR: String?
    var category: String?
    var categoryAR: String?
    var timmings: String?
    var timmingsAR: String?
    var instagram: String?
    var logoImage: String?
    var videoLink: String?
    var pdfMenu: String?
    var isFavorite: Int = 0
    var bannerImage: String?
    var bannerImages: [String]?
    var branches: [BranchModel]?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["merchant_id"]
        name <- map["name"]
        nameAR <- map["ar_merchant_name"]
        category <- map["category"]
        categoryAR <- map["ar_category"]
        timmings <- map["office_timing"]
        timmingsAR <- map["ar_office_timing"]
        instagram <- map["insta_detail"]
        logoImage <- map["image"]
        isFavorite <- map["is_favorite"]
        videoLink <- map["video_link"]
        pdfMenu <- map["menu_pdf"]
        bannerImage <- map["default_banner"]
        bannerImages <- map["banner_image"]
        branches <- map["branches"]
    }
}
