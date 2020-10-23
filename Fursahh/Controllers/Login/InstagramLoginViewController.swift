//
//  InstaLoginViewController.swift
//  Fursahh
//
//  Created by Akber Sayni on 06/08/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit
import WebKit

protocol InstagramLoginDelegate {
    func didHandleAuthToken(_ token: String)
}

class InstagramLoginViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var delegate: InstagramLoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        webView.delegate = self
        webView.loadRequest(urlRequest)
    }
    
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    func handleAuth(authToken: String) {
        //API.INSTAGRAM_ACCESS_TOKEN = authToken
        print("Instagram authentication token ==", authToken)
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate?.didHandleAuthToken(authToken)
            }
        }
        
//        getUserInfo(){(data) in
//            DispatchQueue.main.async {
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
//    func getUserInfo(completion: @escaping ((_ data: Bool) -> Void)){
//        let url = String(format: "%@%@", arguments: [API.INSTAGRAM_USER_INFO,API.INSTAGRAM_ACCESS_TOKEN])
//        var request = URLRequest(url: URL(string: url)!)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            guard error == nil else {
//                completion(false)
//                //failure
//                return
//            }
//            // make sure we got data
//            guard let responseData = data else {
//                completion(false)
//                //Error: did not receive data
//                return
//            }
//            do {
//                guard let dataResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
//                    as? [String: AnyObject] else {
//                        completion(false)
//                        //Error: did not receive data
//                        return
//                }
//                completion(true)
//                // success (dataResponse) dataResponse: contains the Instagram data
//            } catch let err {
//                completion(false)
//                //failure
//            }
//        })
//        task.resume()
//    }
}

extension InstagramLoginViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
}
extension InstagramLoginViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request){
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
        }
    }
}
