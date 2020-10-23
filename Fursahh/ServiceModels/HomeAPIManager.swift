//
//  HomeAPIManager.swift
//  Fursahh
//
//  Created by Akber Sayni on 25/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class HomeAPIManager: APIManagerBase {
    func getHomeData(params: Parameters, success: @escaping DefaultAPISuccessClosure, failure: @escaping DefaultAPIFailureClosure) {
        if let route = POSTURLforRoute(route: WebRoute.home.rawValue) {
            self.postRequestWith(route: route, parameters: params, success: { (response) in
                if let data = response["body"] as? Dictionary<String, AnyObject> {
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
