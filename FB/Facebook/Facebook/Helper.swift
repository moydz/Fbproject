//
//  Helper.swift
//  Facebook
//
//  Created by ITApps on 8/10/18.
//  Copyright © 2018 ITApps. All rights reserved.
//

import UIKit



class Helper{
    
    
    // validate email address function
    func isValid(email: String) -> Bool{
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: email)
        
        return result
    }
    
    
    // validate name function
    func isValid(name: String) -> Bool{
        
        let regex = "[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: name)
        
        return result
    }
    
}
