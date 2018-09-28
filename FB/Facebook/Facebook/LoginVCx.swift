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
    
    
    
    //variable
    var stado = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        if(stado == 0){
            coverImageView_top.constant -= 75
            handsImageView_top.constant  -= 75
            whiteIconImageView_y.constant += 50
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                registrerButton_buttom.constant += keyboardSize.height
            }
            stado = 1
        }
        
        
        
        //animation function . ocultamos la imagen
        UIView.animate(withDuration: 0.5){
            self.handsImageView.alpha = 0
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        coverImageView_top.constant += 75
        handsImageView_top.constant  += 75
        whiteIconImageView_y.constant -= 50
        stado = 0
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            registrerButton_buttom.constant -= keyboardSize.height
        }
        
        //animation function. mostramos la imagen
        UIView.animate(withDuration: 0.5){
            self.handsImageView.alpha = 1
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
    

}
