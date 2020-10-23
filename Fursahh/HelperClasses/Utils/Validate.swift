//
//  Validate.swift
//  ProQ
//
//  Created by Akber Sayni on 23/02/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class Validate: NSObject {
    
    static func isValidEmailAddress(_ text: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: text)
    }
    
    static func isValidPassword(_ text: String) -> Bool {
        let regex = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[@#$%^&+=])(?=\\S+$)(?!.*(.)\\1).{8,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: text)
    }
}
