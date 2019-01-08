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
    
    
    //show alert message to the user
    func showAlert(title: String, message: String, from: UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        from.present(alert, animated: true, completion: nil)
        
        
    }
    
    // allows us to go to another ViewController
    func instantiateViewController(id: String, animate: Bool, by vc:UIViewController, completion:(() -> Void)?){
        
        // accessing any viewController from Main.Stroryboard via ID
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)
        vc.present(newViewController, animated: animate, completion: completion)
        
        
    }
    
    //Mine for the image
    func body(with parameters:[String: Any]?, filename: String,filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData{
        
        let body = NSMutableData()
        
        // Mine Type for parameters
        if parameters != nil {
            for(key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        let minetype = "image/jpg"
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Disposition: \(minetype)\r\n\r\n".utf8))
        
        body.append(imageDataKey)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)\r\n".utf8))
        
        return body
    }
    
   
    func downloadImage(from path:String , showIn imageView: UIImageView, orShow placeholder: String){
        
        // if avaPath string is having a valid url
        if String(describing: path).isEmpty == false {
            DispatchQueue.main.async {
                if let url = URL(string: (path)){
                    
                    guard let data = try? Data(contentsOf: url) else{
                        imageView.image = UIImage(named: placeholder)
                        return
                    }
                    
                    // converting donwloaded data to imger
                    guard let image = UIImage(data: data) else {
                        imageView.image = UIImage(named: placeholder)
                        return
                    }
                    
                    // assigning image to the imageView
                    
                    imageView.image = image
                }
                
                
            }
            
        }
        
        
    }
    
    
    func getUrlServer() -> String {
         let url = "http://172.23.112.251/"
         return url
    }
    
    
    
}//end helper
