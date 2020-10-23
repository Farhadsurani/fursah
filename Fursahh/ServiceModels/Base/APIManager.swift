//
//  APIManager.swift
//  The Court Lawyer
//
//  Created by Ahmed Shahid on 5/3/18.
//  Copyright © 2018 Akber Sayani All rights reserved.
//

import Foundation
import UIKit

typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void
typealias DefaultArrayResultAPISuccessClosure = (Array<AnyObject>) -> Void
typealias DefaultImageResultClosure = (UIImage) -> Void
typealias DefaultAPIAnyObject = (AnyObject) -> Void

// Download closures
typealias DefaultDownloadSuccessClosure = (Data) -> Void
typealias DefaultDownloadProgressClosure = (Double, Int) -> Void
typealias DefaultDownloadFailureClosure = (NSError, Data, Bool) -> Void


protocol APIErrorHandler {
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromERror(error:NSError)
}


class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    var serverToken: String? {
        get{
            return "" // AppStateManager.sharedInstance.loggedInUser.token
        }
    }
    
    let user = UsersAPIManager()
    let home = HomeAPIManager()
    let merchant = MerchantAPIManager()
}
