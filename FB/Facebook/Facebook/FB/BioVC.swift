//
//  BioVC.swift
//  Facebook
//
//  Created by ITApps on 1/7/19.
//  Copyright © 2019 ITApps. All rights reserved.
//

import UIKit

class BioVC: UIViewController, UITextViewDelegate{

    // ui obj
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // run funsc
        configure_avaImageView()
        loadUser()
    }

    
    
    // configuring the appearance of AvaImageView
    func configure_avaImageView() {
        
        // creating layer that will be applied to avaImageView (layer - broders of ava)
        /*let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = 5
        border.frame = CGRect(x: 0, y: 0, width: avaImageView.frame.width, height: avaImageView.frame.height)
        avaImageView.layer.addSublayer(border)*/
        
        // rounded corners
        avaImageView.layer.cornerRadius = avaImageView.frame.width / 2
        avaImageView.layer.masksToBounds = true
        avaImageView.clipsToBounds = true
    }
    
    
    // loads all user related information to be shiown in the header
    func loadUser(){
        
        // safe method of accessing user related information in glob user
        guard let firstName = currentUser?["firstName"],
            let lastName = currentUser?["lastName"],
            let avaPath = currentUser?["ava"]
        else {
            return
        }
        
        // assigning vars which ws accessed fro global var , to fullnameLabel
        fullnameLabel.text = "\((firstName as! String).capitalized) \((lastName as! String).capitalized)"
        
        // downloading the images and assigning to certain imageview
        Helper().downloadImage(from: avaPath as! String, showIn: avaImageView, orShow: "user.png")
       
        
    }
    
    // exeuted whenever we are typing some text in the Textview object which has delegate with the viewController
    func textViewDidChange(_ textView: UITextView) {
        
        // calculation of characters
        let allowed = 101
        let typed = textView.text.count
        let remaining = allowed - typed
        
        counterLabel.text = "\(remaining)/101"
        
        // if some text is in textview
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
        }
        
    }
    
    // executed Firtly whenever tectView is about to be change. return TRUE --> allow
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        
        return textView.text.count + (text.count - range.length) <= 101
        
    }
    
    
    @IBAction func saveButton_clicked(_ sender: Any) {
        
        // run updateBio function if there are no whitelines and white spaces
        if bioTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false {
            self.updateBio()
        }
        
    }
    
    
    // updating bio by sending requents to the server
    func updateBio(){
        
        guard  let id = currentUser?["id"],
               let bio = bioTextView.text
            else{
                return
        }
    
        let server = Helper().getUrlServer()
        let url = URL(string: "\(server)fb/updateBio.php")!
        let body = "id=\(id)&bio=\(bio)"
        // declaring reqeust with further configs
        var request = URLRequest(url: url)
        // POST - safest method of passing data to the server
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        
        
        // STEP 3. Execute and Launch Request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                // error
                if error != nil {
                    Helper().showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    return
                }
                
                // go to data and jsoning
                do {
                    
                    // save method of casting data received from the server
                    guard let data = data else {
                        Helper().showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                        return
                    }
                    
                    // STEP 4. Parse JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    // save method of casting json
                    guard let parsedJSON = json else {
                        return
                    }
                    
                    // updated successfully
                    if parsedJSON["status"] as! String == "200" {
                        
                        // save updated user information in the app
                        currentUser = parsedJSON.mutableCopy() as? NSMutableDictionary
                        UserDefaults.standard.set(currentUser, forKey: "currentUser")
                        UserDefaults.standard.synchronize()
                        
                        // post notification -> update Bio on Home Page
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBio"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                        
                        // error while updating (e.g. Status = 400)
                    } else {
                        Helper().showAlert(title: "400", message: "Error while updating the bio", from: self)
                    }
                    
                    // error while processing/accessing json
                } catch {
                    Helper().showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                }
                
            }
            
            }.resume()
        
    }
    
    
    @IBAction func cancelButton_clicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
