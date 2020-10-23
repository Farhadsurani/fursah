//
//  NotificationModel.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationModel: NSObject, Mappable {
    var title: String?
    var category: String?
    var message: String?
    var dateTime: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        category <- map["category"]
        message <- map["message"]
        dateTime <- map["created_at"]
    }
}
