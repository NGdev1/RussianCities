//
//  DataCheck.swift
//  epass
//
//  Created by Михаил Андреичев on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class DataCheck {
    
    static func check(request : Any) -> String? {
        
        return nil
    }
    
    private static func validatePhoneNumber(_ candidate: String) -> Bool {
        let phoneNumberRegex = "^\\([0-9]{3}\\)[0-9]{3}-[0-9]{2}-[0-9]{2}$"
        
        let isValid = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: candidate)
        
        return isValid
    }
}
