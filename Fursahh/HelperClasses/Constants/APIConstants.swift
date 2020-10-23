//
//  APIConstants.swift
//  ProQ
//
//  Created by Akber Sayni on 19/02/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

enum WebRoute: String {
    func url() -> String{
        return APIConstants.BaseURL + self.rawValue
    }

    // MARK: - User
    case registerUser = "/registercustomer"
    case loginUser = "/login"
    case changePassword = "/changepassword"
    case updateProfile = "/updateprofile"
    case emailVerification = "/sendotp"
    case verifyOTP = "/verifyotp"
    case loginWithFacebook = "/loginwithfacebook"
    case loginWithInstagram = "/loginwithinstagram"
    case newPassword = "/changepasswordforget"
    case registerToken = "/update_push_id"
    case getSavingDetails = "/totalamountsaved"
    case getUserNotifications = "/notificationlist"

    // MARK: - Home
    case home = "/home"
    
    // MARK: - Merchant
    case merchantList = "/merchantlist"
    case merchantDetails = "/merchantdetailbyid"
    case merchantOffers = "/merchantdetail"
    case addFavorite = "/addfavorite"
    case getFavorites = "/viewfavorite"
    case redeemVoucher = "/offerredeem"
    case getRedeemedVouchers = "/redemptionhistory"

    // MARK: - Search
    case getSearchAttributes = "/getallattributes"
    case searchMerchants = "/merchantdetailbyname"
    case searchMerchantWithAttributes = "/searchallattributes"
}

class APIConstants: NSObject {
    static let BaseURL = "http://fursahh.com/admin/Services"
}
