//
//  LoginVCx.swift
//  Facebook
//
//  Created by ITApps on 13/9/18.
//  Copyright © 2018 ITApps. All rights reserved.
//

import UIKit

class LoginVCx: UIViewController {

    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var rightLineView: UIView!
    @IBOutlet weak var registrerButton: UIButton!
    @IBOutlet weak var handsImageView: UIImageView!
    
    //constraints
    @IBOutlet weak var coverImageView_top: NSLayoutConstraint!
    @IBOutlet weak var whiteIconImageView_y: NSLayoutConstraint!
    @IBOutlet weak var handsImageView_top: NSLayoutConstraint!
    @IBOutlet weak var registrerButton_buttom: NSLayoutConstraint!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // cache obj
    var coverImageView_top_cache: CGFloat!
    var whiteIconImageView_y_cache: CGFloat!
    var handsImageView_top_cache: CGFloat!
    var registerButton_bottom_cache: CGFloat!
    
    //variable
    var stado = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // caching all values of constraints
        coverImageView_top_cache = coverImageView_top.constant
        whiteIconImageView_y_cache = whiteIconImageView_y.constant
        handsImageView_top_cache = handsImageView_top.constant
        registerButton_bottom_cache = registrerButton_buttom.constant
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        
        // deducting 75pxls from current Y position (doesn't act till forced)
        coverImageView_top.constant -= 75
        handsImageView_top.constant -= 75
        whiteIconImageView_y.constant += 50
        
        /*
         coverImageView_top.constant = -self.view.frame.width / 5.52
         handsImageView_top.constant = -self.view.frame.width / 5.52
         whiteIconImageView_y.constant = self.view.frame.width / 8.28
         */
        
        // if iOS (app) is able to access keyboard's frame, then change Y position of the Register Button
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            registrerButton_buttom.constant += keyboardSize.height
            //registerButton_bottom.constant = self.view.frame.width / 1.75423
        }
        
        // animation function. Whatever in the closures below will be animated
        UIView.animate(withDuration: 0.5) {
            
            self.handsImageView.alpha = 0
            
            // force to update the layout
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        // returning all objects to its initial positions
        coverImageView_top.constant = coverImageView_top_cache
        handsImageView_top.constant = handsImageView_top_cache
        whiteIconImageView_y.constant = whiteIconImageView_y_cache
        registrerButton_buttom.constant = registerButton_bottom_cache
        
        // animation function. Whatever in the closures below will be animated
        UIView.animate(withDuration: 0.5) {
            
            self.handsImageView.alpha = 1
            
            // force to update the layout
            self.view.layoutIfNeeded()
            
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configure_textFieldsView()
        configure_loginBtn()
        configure_orLabel()
        configure_registrerButton()
    }
    
    func configure_textFieldsView(){
        
        let width = CGFloat(2)
        let color = UIColor.groupTableViewBackground.cgColor
        
        let border = CALayer()
        border.borderColor = color
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: 0, width: textFieldsView.frame.width, height: textFieldsView.frame.height)
        
        let line = CALayer()
        line.borderWidth = width
        line.borderColor = color
        line.frame = CGRect(x: 0, y: textFieldsView.frame.height / 2 - width, width: textFieldsView.frame.width, height: width)
        
        textFieldsView.layer.addSublayer(border)
        textFieldsView.layer.addSublayer(line)
        
        textFieldsView.layer.cornerRadius = 5
        textFieldsView.layer.masksToBounds = true
        
    }
    
    func configure_loginBtn(){
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        //loginButton.isEnabled = false
        
    }
    
    
    func configure_orLabel(){
        
        let width = CGFloat(2)
        let color = UIColor.groupTableViewBackground.cgColor
        
        let leftLine = CALayer()
        leftLine.borderWidth = width
        leftLine.borderColor = color
        leftLine.frame = CGRect(x: 0, y: leftLineView.frame.height / 2 - width, width: leftLineView.frame.width, height: width)
        
        let rightLine = CALayer()
        rightLine.borderWidth = width
        rightLine.borderColor = color
        rightLine.frame = CGRect(x: 0, y: rightLineView.frame.height / 2 - width, width: rightLineView.frame.width, height: width)
        
        
        
        leftLineView.layer.addSublayer(leftLine)
        rightLineView.layer.addSublayer(rightLine)
    }
    
    
    func configure_registrerButton(){
        
        let border = CALayer()
        border.borderColor = UIColor.groupTableViewBackground.cgColor
        border.borderWidth = 2
        border.frame = CGRect(x: 0, y: 0, width: registrerButton.frame.width, height: registrerButton.frame.height)
        
        registrerButton.layer.addSublayer(border)
        registrerButton.layer.cornerRadius = 5
        registrerButton.layer.masksToBounds = true
        
    }
    
    
    // execute when the button is pressed
    @IBAction func loginButton_clicked(_ sender: Any) {
        
        // accessing Helper Class
        let helper = Helper()
        
        // if entered text in  Email doesn't match
        if helper.isValid(email: emailTextField.text!) == false{
            helper.showAlert(title: "Invalid Email", message: "Please enter registered Email address", from: self)
            return
         // if password is less than 6 chars
        }else if passwordTextField.text!.count < 6 {
            helper.showAlert(title: "Invalid Password", message: "Password must containt at least 6 characters", from: self)
            return
        }
        
        // run loginRequerst func
        loginRequest()
        
    }
    
    // sending request ti the server
    func loginRequest(){
        
        let server = Helper().getUrlServer()
        let url = URL(string: "\(server)fb/login.php")
        let body = "email=\(emailTextField.text!.lowercased())&password=\(passwordTextField.text!)"
        
        var request = URLRequest(url: url!)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {

            let helper = Helper()
            if error != nil{
                helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                return
            }
            
            // fetch JSO
            do{
                
                guard let data = data else{
                    helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                    return
                }
                
                let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                // save mode of casting JSON
                guard let parsedJSON = json else{
                    print("Parsing Error")
                    return
                }
                
                if parsedJSON["status"] as! String == "200" {
                    // go to TabBar
                    helper.instantiateViewController(id: "TabBar", animate: true, by: self, completion: nil)
                    
                    //savin logged user
                    currentUser = parsedJSON.mutableCopy() as? NSMutableDictionary
                    UserDefaults.standard.set(currentUser, forKey: "currentUser")
                    UserDefaults.standard.synchronize()
                    
                }else{
                    if parsedJSON["message"] != nil{
                        let message = parsedJSON["message"] as! String
                        helper.showAlert(title: "Password Incorrect", message: message, from: self)
                    }
                }
                
                print(parsedJSON)
                // error while
            } catch {
                helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
            }
            
            }
            }.resume()
        
    }
    
}
