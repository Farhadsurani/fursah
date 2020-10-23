//
//  Constants.swift
//  ProQ
//
//  Created by Akber Sayni on 15/02/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

struct Constants {
    static let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
}

struct API {
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
    static let INSTAGRAM_CLIENT_ID = "c11dd1a5f92b4e3bbc760cf665a35b34"
    static let INSTAGRAM_CLIENT_SERCRET = "2e8ffaf3229c4251811329105ae7b78e"
    static let INSTAGRAM_REDIRECT_URI = "http://fursahh.com"
	static let INSTAGRAM_SCOPE = "basic"
    //static let INSTAGRAM_SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
}

