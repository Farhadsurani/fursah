//
//  UserAPIManager.swift
//  The Court Lawyer
//
//  Created by Ahmed Shahid on 5/3/18.
//  Copyright © 2018 Ahmed Shahid. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class UsersAPIManager: APIManagerBase {
    func registerUser(params: Parameters, success: @escaping DefaultAPIAnyObject, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.registerUser.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let result = response["body"] {
                    success(result)
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }

    func loginUser(params: Parameters, success: @escaping DefaultAPIAnyObject, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.loginUser.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let result = response["body"] {
                    success(result)
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func loginWithFacebook(params: Parameters, success: @escaping DefaultAPIAnyObject, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.loginWithFacebook.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let result = response["body"] {
                    success(result)
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func loginWithInstagram(params: Parameters, success: @escaping DefaultAPIAnyObject, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.loginWithInstagram.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let result = response["body"] {
                    success(result)
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func updateUserProfile(params: Parameters, queryParams: Parameters, success: @escaping DefaultAPIAnyObject, failure: @escaping DefaultAPIFailureClosure) {
        if let route = GETURLfor(route: WebRoute.updateProfile.rawValue, params: queryParams) {
            self.postRequestWithMultipart(route: route, parameters: params, success: { (response) in
                if let data = response["body"] {
                    success(data)
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure)
        }
    }
    
    func changePassword(params: Parameters, success: @escaping DefaultBoolResultAPISuccesClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.changePassword.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                success(true)
            }, failure: failure, withHeaders: true)
        }
    }
    
    func emailVerification(params: Parameters, success: @escaping DefaultBoolResultAPISuccesClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.emailVerification.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                success(true)
            }, failure: failure, withHeaders: true)
        }
    }
    
    func verifyCode(params: Parameters, success: @escaping DefaultBoolResultAPISuccesClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.verifyOTP.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                success(true)
            }, failure: failure, withHeaders: true)
        }
    }
    
    func newPassword(params: Parameters, success: @escaping DefaultBoolResultAPISuccesClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.newPassword.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                success(true)
            }, failure: failure, withHeaders: true)
        }
    }
    
    func registerDeviceToken(params: Parameters, success: @escaping DefaultBoolResultAPISuccesClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.registerToken.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                success(true)
            }, failure: failure, withHeaders: true)
        }
    }
    
    func getSavingDetails(params: Parameters, success: @escaping DefaultAPIAnyObject, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.getSavingDetails.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let result = response["body"] {
                    success(result)
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func getUserNotifications(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.getUserNotifications.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let result = response["body"] as? [AnyObject] {
                    success(result)
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }

}
