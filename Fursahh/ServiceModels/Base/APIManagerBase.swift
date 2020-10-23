//
//  APIManagerBase.swift
//  The Court Lawyer
//
//  Created by Ahmed Shahid on 5/3/18.
//  Copyright © 2018 Ahmed Shahid. All rights reserved.


import Foundation
import UIKit
import Alamofire
import SwiftyJSON
//import AlamofireImage

class APIManagerBase: NSObject {
    let baseURL = APIConstants.BaseURL
    let defaultRequestHeader = ["Content-Type": "application/json"]
    let defaultError = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request Failed."])
    
    func getAuthorizationHeader() -> Dictionary<String,String> {
        if let languageCode = Locale.current.languageCode {
            return ["Accept-Language": languageCode]
        }
        
        return defaultRequestHeader
    }
    
    func getErrorFromResponseData(data: Data) -> NSError? {
        do{
            let result = try JSONSerialization.jsonObject(with: data,options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String,AnyObject>>
            if let message = result?[0]["message"] as? String{
                let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                return error;
            }
        }catch{
            NSLog("Error: \(error)")
        }
        return nil
    }
    
    func URLforRoute(route: String,params:[String: Any]) -> NSURL? {
        if let components: NSURLComponents  = NSURLComponents(string: (APIConstants.BaseURL+route)){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params {
                queryItems.append(NSURLQueryItem(name:key,value: "\(value)"))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            return components.url as NSURL?
        }
        return nil;
    }
    
    func POSTURLforRoute(route:String) -> URL?{
        if let components: NSURLComponents = NSURLComponents(string: (APIConstants.BaseURL+route)){
            return components.url! as URL
        }
        return nil
    }
    
    func GETURLfor(route:String) -> URL?{        
        if let components: NSURLComponents = NSURLComponents(string: (APIConstants.BaseURL+route)){
            return components.url! as URL
        }
        return nil
    }
    
    func GETURLfor(route: String, params:[String: Any]) -> URL? {
        if let components: NSURLComponents  = NSURLComponents(string: (APIConstants.BaseURL+route)){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params{
                queryItems.append(NSURLQueryItem(name:key,value: "\(value)"))
            }
            components.queryItems = queryItems as [URLQueryItem]?
            
            return components.url as URL?
        }
        return nil;
    }
    
    // MARK: MULTIPART REQUESTS
    
    func postRequestWithMultipartForCreateRequest(route: URL,parameters: Parameters, images: [UIImage],
                                                  success:@escaping DefaultAPISuccessClosure,
                                                  failure:@escaping DefaultAPIFailureClosure){
        Alamofire.upload (
            multipartFormData: { multipartFormData in
                for (key , value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                }
                for item in images {
                    let image = item.jpegData(compressionQuality: 0.5)
                    if let data:Data = image {
                        multipartFormData.append(data, withName: "images[]", fileName: "fileName.jpg", mimeType: data.mimeType)
                    }
                }
                
        },
            to: route,
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        self.responseResult(response, success: {result in
                            success(result as! Dictionary<String, AnyObject>)
                        }, failure: {error in
                            failure(error)
                        })
                    }
                case .failure(let encodingError):
                    failure(encodingError as NSError)
                }
        }
        )
    }
    
    func postRequestWithMultipart(route: URL,parameters: Parameters,
                                  success:@escaping DefaultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure){
        Alamofire.upload (
            multipartFormData: { multipartFormData in
                for (key , value) in parameters {
                    if let data:Data = value as? Data {
                        multipartFormData.append(data, withName: key, fileName: "fileName.jpeg", mimeType: "image/jpeg")
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
                
        },
            to: route,
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        self.responseResult(response, success: {result in
                            
                            success(result as! Dictionary<String, AnyObject>)
                        }, failure: {error in
                            
                            failure(error)
                        })
                    }
                case .failure(let encodingError):
                    failure(encodingError as NSError)
                }
        }
        )
    }
    
    func postRequestWithMultipart(route: URL,parameters: Parameters,
                                  success:@escaping DefaultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure , withHeader: Bool = true){
        if withHeader{
            Alamofire.upload(multipartFormData:{ multipartFormData in
                for (key , value) in parameters {
                    if let data:Data = value as? Data {
                        //multipartFormData.append(data, withName: key, fileName: "fileName.jpeg", mimeType: "image/jpeg")
                        multipartFormData.append(data, withName: key, fileName: "\(data.getExtension)", mimeType: "\(data.mimeType)")
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            },
                             usingThreshold:UInt64.init(),
                             to: route,
                             method:.post,
                             headers: getAuthorizationHeader(),
                             encodingCompletion: { result in
                                switch result {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        self.responseResult(response, success: {result in
                                            
                                            success(result as! Dictionary<String, AnyObject>)
                                        }, failure: {error in
                                            
                                            failure(error)
                                        })
                                    }
                                case .failure(let encodingError):
                                    failure(encodingError as NSError)
                                }
            }
                
            )
            
            
        }else{
            Alamofire.upload (
                multipartFormData: { multipartFormData in
                    for (key , value) in parameters {
                        if let data:Data = value as? Data {
                            multipartFormData.append(data, withName: key, fileName: "fileName.jpeg", mimeType: "image/jpeg")
                        } else {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                        }
                    }
                    
            },
                to: route,
                encodingCompletion: { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.responseResult(response, success: {result in
                                success(result as! Dictionary<String, AnyObject>)
                            }, failure: {error in
                                
                                failure(error)
                            })
                        }
                    case .failure(let encodingError):
                        failure(encodingError as NSError)
                    }
            }
            )
        }
    }
    
    func postRequestWithMultipart(route: URL,parameters: Parameters,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure , withHeader: Bool = true){
        if withHeader{
            Alamofire.upload(multipartFormData:{ multipartFormData in
                for (key , value) in parameters {
                    if let data:Data = value as? Data {
                        multipartFormData.append(data, withName: key, fileName: "\(data.getExtension)", mimeType: "\(data.mimeType)")
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            },
                             usingThreshold:UInt64.init(),
                             to: route,
                             method:.post,
                             headers: getAuthorizationHeader(),
                             encodingCompletion: { result in
                                switch result {
                                case .success(let upload, _, _):
                                    upload.responseJSON { response in
                                        self.responseResult(response, success: {result in
                                            
                                            success(result as! Array<AnyObject>)
                                        }, failure: {error in
                                            
                                            failure(error)
                                        })
                                    }
                                case .failure(let encodingError):
                                    failure(encodingError as NSError)
                                }
            }
                
            )
            
            
        }else{
            Alamofire.upload (
                multipartFormData: { multipartFormData in
                    for (key , value) in parameters {
                        if let data:Data = value as? Data {
                            multipartFormData.append(data, withName: key, fileName: "fileName.jpeg", mimeType: "image/jpeg")
                        } else {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                        }
                    }
                    
            },
                to: route,
                encodingCompletion: { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.responseResult(response, success: {result in
                                
                                success(result as! Array<AnyObject>)
                            }, failure: {error in
                                
                                failure(error)
                            })
                        }
                    case .failure(let encodingError):
                        failure(encodingError as NSError)
                    }
            }
            )
        }
    }
    
    // MARK: POST REQUESTS
    
    func postRequestWith(route: URL,parameters: Parameters,
                         success:@escaping DefaultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure, withHeaders: Bool = true){
        
        if withHeaders {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(response as! Dictionary<String, AnyObject>)
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(response as! Dictionary<String, AnyObject>)
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }
    }
    
    func postRequestArrayWith(route: URL,parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure, withHeaders:Bool = true){
        
        if withHeaders {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                self.responseResult(response, success: {response in
                    
                    success(response as! [AnyObject])
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(response as! [AnyObject])
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }
    }
    
    
    func postRequestForBoolWith(route: URL,parameters: Parameters,
                                success:@escaping DefaultBoolResultAPISuccesClosure,
                                failure:@escaping DefaultAPIFailureClosure, withHeaders:Bool = true){
        
        if withHeaders {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(true)
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }else {
            Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(true)
                }, failure: {error in
                    
                    failure(error as NSError)
                })
            }
        }
    }
    
    // MARK: GET REQUESTES
    
    func getRequestWith(route: URL,parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure, withHeader: Bool = true) {
        if(withHeader)
        {
            Alamofire.request(route, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                
                self.responseResult(response, success: {
                    
                    response in
                    
                    success(response as! Array<AnyObject>)
                }, failure: {error in
                    
                    failure(error as NSError)
                })}
            
        }
        else
        {
            Alamofire.request(route, method: .get, parameters: parameters, encoding: URLEncoding()).responseJSON {
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(response as! Array<AnyObject>)
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
    }
    
    func getRequestForDictionaryWith(route: URL,
                                     success:@escaping DefaultAPISuccessClosure,
                                     failure:@escaping DefaultAPIFailureClosure, withHeader: Bool = true) {
        if(withHeader)
        {
            Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(response as! Dictionary<String, AnyObject>)
                    
                }, failure: {error in
                    failure(error as NSError)
                })
                
            }
            
        }
        else
        {
            Alamofire.request(route, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(response as! Dictionary<String, AnyObject>)
                    
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        
    }
    
    func getRequestForBoolWith(route: URL,
                               success:@escaping DefaultBoolResultAPISuccesClosure,
                               failure:@escaping DefaultAPIFailureClosure, withHeader: Bool = true) {
        if(withHeader)
        {
            Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(true)
                    
                }, failure: {error in
                    failure(error as NSError)
                })
                
            }
            
        }
        else
        {
            
            Alamofire.request(route, method: .get , parameters: nil, encoding: JSONEncoding.default).responseJSON{
                response in
                
                self.responseResult(response, success: {response in
                    
                    success(true)
                    
                }, failure: {error in
                    failure(error as NSError)
                })
            }
        }
        
    }
    
    
    func putRequestWith(route: URL,parameters: Parameters,
                        success:@escaping DefaultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            
            self.responseResult(response, success: {response in
                
                success(response as! Dictionary<String, AnyObject>)
            }, failure: {error in
                
                failure(error as NSError)
            })
        }
    }
    
    func deleteRequestWith(route: URL,parameters: Parameters,
                           success:@escaping DefaultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            
            self.responseResult(response, success: {response in
                
                success(response as! Dictionary<String, AnyObject>)
            }, failure: {error in
                
                failure(error as NSError)
            })
        }
    }
    
    func deleteRequestWithT(endPoint: String, success:@escaping DefaultAPISuccessClosure, failure:@escaping DefaultAPIFailureClosure) {
        Alamofire.request(endPoint, method: .delete, headers:getAuthorizationHeader())
            .responseJSON { response in
                self.responseResult(response, success: {response in
                    
                    success(response as! Dictionary<String, AnyObject>)
                }, failure: {error in
                    
                    failure(error as NSError)
                })
        }
    }
    
    // MARK: DOWNLOAD FILE
    func downloadWith(downloadUrl:String, saveUrl:String, index: Int, success: @escaping DefaultDownloadSuccessClosure, downloadProgress: @escaping DefaultDownloadProgressClosure, failure: @escaping DefaultDownloadFailureClosure) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let file = directoryURL.appendingPathComponent(saveUrl + ".m3u8", isDirectory: false)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }
        Alamofire.download(downloadUrl, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                downloadProgress(progress.fractionCompleted,index)
            }
            .responseData(completionHandler: {
                response in
                if response.result.error == nil {
                    //print("Success: Downloading file: \(response.request) completed.")
                    if let data = response.result.value {
                        success(data)
                    }
                }else {
                    print("Error : \(response.result.error.debugDescription)")
                    let errorMessage = response.result.error.debugDescription
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    let error = NSError(domain: "Domain", code: 1000 , userInfo: userInfo)
                    if response.resumeData != nil {
                        failure(error,response.resumeData!, true)
                    }else {
                        failure(error,Data(),false)
                    }
                    
                }
            })
    }
    
    func resumeWith (data: Data, index: Int, saveUrl:String, success: @escaping DefaultDownloadSuccessClosure, downloadProgress: @escaping DefaultDownloadProgressClosure, failure: @escaping DefaultDownloadFailureClosure) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let file = directoryURL.appendingPathComponent(saveUrl + ".mp3", isDirectory: false)
            return (file, [.createIntermediateDirectories])
            
        }
        Alamofire.download(resumingWith: data, to: destination).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
            downloadProgress(progress.fractionCompleted,index)
            }
            .responseData(completionHandler: {
                response in
                print(response.result.isSuccess)
                if response.result.error == nil {
                    //print("Success: Downloading file: \(response.request) completed.")
                    if let data = response.result.value {
                        success(data)
                    }
                }else {
                    print("Error : \(response.result.error.debugDescription)")
                    let errorMessage = response.result.error.debugDescription
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    let error = NSError(domain: "Domain", code: 1000 , userInfo: userInfo)
                    if response.resumeData != nil {
                        failure(error,response.resumeData!, true)
                    }else {
                        failure(error,Data(),false)
                    }
                    
                }
            })
        
    }
    
    // MARK: Closing downloadImageT
    //    func downloadImageT(route: String, success:@escaping DefaultImageResultClosure) {
    //        Alamofire.request(route).responseData { response in
    //            self.responseImage(response, success: success)
    //        }
    //    }
    fileprivate func responseImage(_ response: DataResponse<UIImage>, success: @escaping (_ response: UIImage) -> Void) {
        if let image = response.result.value {
            print(image)
            success(image)
        }
    }
    
    //MARK: - Response Handling
    fileprivate func responseResult(_ response:DataResponse<Any>,
                                    success: @escaping (_ response: AnyObject) -> Void,
                                    failure: @escaping (_ error: NSError) -> Void
        ) {
        switch response.result
        {
        case .success:
            if let dictData = response.result.value as? NSDictionary {
                if let header = dictData["header"] as? NSDictionary {
                    if let status = header["success"] as? String, status == "1" {
                        success(dictData)
                    } else {
                        let defaultErrorMessage = "Something went wrong. Please try again"
                        let errorMessage = (header["message"] as? String) ?? defaultErrorMessage
                        let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                        failure(NSError(domain: "Error", code: 1, userInfo: userInfo))
                    }
                } else {
                    // Failure message
                    let errorMessage = "Something went wrong. Please try again"
                    let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                    failure(NSError(domain: "Error", code: 0, userInfo: userInfo))
                }
            }
        case .failure(let error):
            failure(error as NSError)
        }
    }
    
    fileprivate func multipartFormData(parameters: Parameters) {
        let formData: MultipartFormData = MultipartFormData()
        if let params:[String:AnyObject] = parameters as [String : AnyObject]? {
            for (key , value) in params {
                
                if let data:Data = value as? Data {
                    formData.append(data, withName: key, fileName: "fileName", mimeType: data.mimeType)
                } else {
                    formData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                }
            }
        }
    }
}


public extension Data {
    var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x25:
                return "application/pdf";
            case 0xD0:
                return "application/vnd";
            case 0x46:
                return "text/plain";
            default:
                print("mimeType for \(c[0]) in available");
                return "application/octet-stream";
            }
        }
    }
    
    var getExtension: String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "_IMG.jpeg";
            case 0x89:
                return "_IMG.png";
            case 0x47:
                return "_IMG.gif";
            case 0x49, 0x4D:
                return "_IMG.tiff";
            case 0x25:
                return "_FILE.pdf";
            case 0xD0:
                return "_FILE.vnd";
            case 0x46:
                return "_FILE.txt";
            default:
                print("mimeType for \(c[0]) in available");
                return "_video.mp4";
            }
        }
    }
}

