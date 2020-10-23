//
//  UserModel.swift
//  Salam-Square
//
//  Created by Akber Sayni on 29/06/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import ObjectMapper

class UserModel: NSObject, Mappable, NSCoding {
    var id: String?
    var name: String?
    var email: String?
    var phone: String?
    var image: String?
    var ageRange: String?
    var location: String?
    var nationality: String?
    var profilePicture: String?
    var emailVerification: String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    convenience required init?(coder decoder: NSCoder) {
        self.init()
        
        self.id = decoder.decodeObject(forKey: "id") as? String
        self.name = decoder.decodeObject(forKey: "name") as? String
        self.email = decoder.decodeObject(forKey: "email") as? String
        self.phone = decoder.decodeObject(forKey: "phone") as? String
        self.image = decoder.decodeObject(forKey: "image") as? String
        self.ageRange = decoder.decodeObject(forKey: "age") as? String
        self.location = decoder.decodeObject(forKey: "location") as? String
        self.nationality = decoder.decodeObject(forKey: "nationality") as? String
        self.profilePicture = decoder.decodeObject(forKey: "profile_pic") as? String
        self.emailVerification = decoder.decodeObject(forKey: "email_verification") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.email, forKey: "email")
        coder.encode(self.phone, forKey: "phone")
        coder.encode(self.image, forKey: "image")
        coder.encode(self.ageRange, forKey: "age")
        coder.encode(self.location, forKey: "location")
        coder.encode(self.nationality, forKey: "nationality")
        coder.encode(self.profilePicture, forKey: "profile_pic")
        coder.encode(self.emailVerification, forKey: "email_verification")
    }
    
    func mapping(map: Map) {
        id <- map["user_id"]
        name <- map["merchant_name"]
        email <- map["email"]
        phone <- map["phone"]
        image <- map["profile_pic"]
        ageRange <- map["age"]
        location <- map["city"]
        nationality <- map["nationality"]
        profilePicture <- map["profile_pic"]
        emailVerification <- map["email_verification"]
    }
}
