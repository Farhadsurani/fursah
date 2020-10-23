//
//  Utility.swift
//  Template
//
//  Created by Akber Sayani on 02/01/2017.
//  Copyright © 2017 Akber Sayani. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import NVActivityIndicatorView

class Utility: NVActivityIndicatorViewable{
    
    func roundAndFormatFloat(floatToReturn : Float, numDecimalPlaces: Int) -> String{
        
        let formattedNumber = String(format: "%.\(numDecimalPlaces)f", floatToReturn)
        return formattedNumber
        
    }

    static func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    static func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }

    func topViewController(base: UIViewController? = (Constants.APP_DELEGATE).window?.rootViewController) -> UIViewController? {
    
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    static func showWillBeImplenentAlert() {
        showAlert(title: "Message", message: "This functionality will be available in next build")
    }
    
    static func showErrorAlert(message: String?) {
        self.showAlert(title: "Error".localized, message: message)
    }
    
    static func showMessageAlert(message: String?) {
        self.showAlert(title: "Message".localized, message: message)
    }
    
    static func showMessageAlert(message: String?, closure: @escaping (UIAlertAction) -> Void) {
        self.showAlert(title: "Message".localized, message: message, closure: closure)
    }

    static func showAlert(title:String?, message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        Utility().topViewController()!.present(alert, animated: true){}
    }
    
    static func showAlert(title:String?, message:String?, buttonText: String = "OK", closure: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default) { onClick in
            closure(onClick)
        })
        Utility().topViewController()!.present(alert, animated: true){}
    }
    
    static func showAlertWithYesNo(title:String?, message:String?, closure: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default) { onClick in
            alert.dismiss(animated: true, completion: {
                //ignore
            })
        })
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { onClick in
            closure(onClick)
        })
        
        Utility().topViewController()!.present(alert, animated: true){}
    }
    
    static func resizeImage(image: UIImage, targetSize: CGFloat) -> UIImage {
        guard (image.size.width > 1024 || image.size.height > 1024) else {
            return image;
        }
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newRect: CGRect = CGRect.zero;
        
        if(image.size.width > image.size.height) {
            newRect.size = CGSize(width: targetSize, height: targetSize * (image.size.height / image.size.width))
        } else {
            newRect.size = CGSize(width: targetSize * (image.size.width / image.size.height), height: targetSize)
        }
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 1.0)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func thumbnailForVideoAtURL(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform=true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }

    static func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    static func showLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let size = CGSize(width: 50, height: 50)
        let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityData = ActivityData(size: size, message: "", messageFont: UIFont.systemFont(ofSize: 12), type: .circleStrokeSpin, color: AppColors.redColor, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: bgColor, textColor: UIColor.black)
        
        //NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    static func hideLoader() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    static func getIndexPathForRow(_ tableView: UITableView, sender: AnyObject) -> IndexPath? {
        let position = sender.convert(CGPoint.zero, to: tableView)
        return tableView.indexPathForRow(at: position)
    }
    
    static func getIndexPathForRow(_ collectionView: UICollectionView, sender: AnyObject) -> IndexPath? {
        let position = sender.convert(CGPoint.zero, to: collectionView)
        return collectionView.indexPathForItem(at: position)
    }
    
    static func getFormatTimeString(_ time: String) -> String? {
        if let time = Int(time) {
            //let hours = Int(time) / 3600
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i", minutes, seconds)
        }
        
        return nil
    }
    
    static func getFormattedDistance(_ distance: String?) -> String {
        let distanceInMeters = Double(distance ?? "0") ?? 0.0
        if distanceInMeters >= 1000.0 {
            return String(format: "%.2f km", distanceInMeters/1000.0)
        } else {
            return String(format: "%.2f m", distanceInMeters)
        }
    }
    
    static func getFormattedDateFromString(_ dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    static func getFormattedDateFromString(_ dateString: String, inputFormat: String, outputFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }


}











