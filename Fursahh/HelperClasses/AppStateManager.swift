//
//  AppStateManager.swift
//  ProQ
//
//  Created by Akber Sayni on 24/02/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class AppStateManager: NSObject {
    static let shared = AppStateManager()
    
    private override init() {
        super.init()
    }
    
    public func saveUserDetails(_ user: UserModel) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "User")
        } catch  {
            print("Failed to archived data")
        }
    }
    
    public func getUserDetails() -> UserModel? {
        if let data = UserDefaults.standard.data(forKey: "User") {
            do {
                if let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserModel {
                    return user
                }
            } catch {
                print("Failed to unarchived data")
            }
        }
        
        return nil
    }
    
    public func getUserId() -> String? {
        if let user = self.getUserDetails() {
            return user.id
        }
        
        return nil
    }
    
    public func isUserLoggedIn() -> Bool {
        if let _ = self.getUserDetails() {
            return true
        }
        
        return false
    }
    
    public func removeUserDetails() {
        UserDefaults.standard.set(nil, forKey: "User")
    }
    
    public func saveDeviceToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "DeviceToken")
    }
    
    public func getDeviceToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: "DeviceToken") {
            return token
        } else {
            return nil
        }
    }
}
