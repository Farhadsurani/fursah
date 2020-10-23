//
//  MerchantAPIManager.swift
//  Fursahh
//
//  Created by Akber Sayni on 27/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class MerchantAPIManager: APIManagerBase {
    func getMerchantList(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.merchantList.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let data = response["body"] as? Array<AnyObject> {
                    success(data)
                }  else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func getMerchantDetails(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.merchantDetails.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let data = response["body"] as? [String: AnyObject] {
                    success(data)
                }  else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func getMerchantOffers(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.merchantOffers.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let body = response["body"] as? [String: AnyObject] {
                    if let data = body["offers"] as? [AnyObject] {
                        success(data)
                    }
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func addMerchantFavorite(params: Parameters, success: @escaping DefaultBoolResultAPISuccesClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.addFavorite.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                success(true)
            }, failure: failure, withHeaders: true)
        }
    }
    
    func getFavoriteMerchants(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.getFavorites.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let data = response["body"] as? Array<AnyObject> {
                    success(data)
                }  else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func redeemVoucher(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.redeemVoucher.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
				if let body = response["body"] as? [String: AnyObject] {
					success(body)
				} else {
					// Failure message
					let errorMessage = "Something went wrong. Please try again"
					let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
					failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
				}
            }, failure: failure, withHeaders: true)
        }
    }
    
    func getRedeemedOffers(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.getRedeemedVouchers.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let body = response["body"] as? [String: AnyObject] {
                    if let data = body["offers"] as? [AnyObject] {
                        success(data)
                    }
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }

    func searchMerchants(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.searchMerchants.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let data = response["body"] as? Array<AnyObject> {
                    success(data)
                }  else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }

    func getSearchAttributes(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.getSearchAttributes.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let data = response["body"] as? [String: AnyObject] {
                    success(data)
                }  else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
    
    func searchMerchantWithAttributes(params: Parameters, success: @escaping DefaultArrayResultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.searchMerchantWithAttributes.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let data = response["body"] as? Array<AnyObject> {
                    success(data)
                }  else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }, failure: failure, withHeaders: true)
        }
    }
}
