//
//  RegistrerVC.swift
//  Facebook
//
//  Created by ITApps on 18/9/18.
//  Copyright © 2018 ITApps. All rights reserved.
//

import UIKit

class RegistrerVC: UIViewController {

    @IBOutlet weak var contentView_width: NSLayoutConstraint!
    @IBOutlet weak var emailView_width: NSLayoutConstraint!
    @IBOutlet weak var nameView_width: NSLayoutConstraint!
    @IBOutlet weak var passwordView_width: NSLayoutConstraint!
    @IBOutlet weak var birthdayView_width: NSLayoutConstraint!
    @IBOutlet weak var gendrView_width: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    
    
    @IBOutlet weak var emailContinueButton: UIButton!
    @IBOutlet weak var fullNameContinueButton: UIButton!
    @IBOutlet weak var passwordContinueButton: UIButton!
    @IBOutlet weak var birthdayContinueButton: UIButton!
    @IBOutlet weak var femaleGenderButton: UIButton!
    @IBOutlet weak var maleGenderButton: UIButton!
    
    
    @IBOutlet weak var footerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView_width.constant = self.view.frame.width * 5
        emailView_width.constant = self.view.frame.width
        nameView_width.constant = self.view.frame.width
        passwordView_width.constant = self.view.frame.width
        birthdayView_width.constant = self.view.frame.width
        gendrView_width.constant = self.view.frame.width
        
        //make corners of the objects rounded
        cornerRadius(for: emailTextField)
        cornerRadius(for: firstNameTextField)
        cornerRadius(for: lastNameTextField)
        cornerRadius(for: passwordTextField)
        cornerRadius(for: birthdayTextField)
        
        cornerRadius(for: emailContinueButton)
        cornerRadius(for: fullNameContinueButton)
        cornerRadius(for: passwordContinueButton)
        cornerRadius(for: birthdayContinueButton)
        
        //apply padding to the textField
        padding(for: emailTextField)
        padding(for: firstNameTextField)
        padding(for: lastNameTextField)
        padding(for: passwordTextField)
        padding(for: birthdayTextField)
        
        configure_footerView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            
            self.configure_button(gender: self.maleGenderButton)
            self.configure_button(gender: self.femaleGenderButton)
        }
        
        
    }

    //make corner rounded for any view
    func cornerRadius(for view: UIView){
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
    }
    
    // add blank view ti the left side of the TextField
    func padding(for textField: UITextField){
        
        let blanckView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = blanckView
        textField.leftViewMode = .always
        
    }
    
    // configure the apparience of the footerView
    func configure_footerView(){
        
        let topLine = CALayer()
        topLine.borderWidth = 1
        topLine.borderColor = UIColor.lightGray.cgColor
        topLine.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1)
        
        footerView.layer.addSublayer(topLine)
        
    }
    
    // configuring the apparence of the gender buttons
    func configure_button(gender button: UIButton){
        
        let border = CALayer()
        border.borderWidth = 1.5
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height)
        
        button.layer.addSublayer(border)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
    }
    
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        let helper = Helper()
        
        if textField == emailTextField{
            if helper.isValid(email: emailTextField.text!){
                print("valid Email")
                emailContinueButton.isHidden = false
            }else{
                emailContinueButton.isHidden = true
            }
        }else if textField == firstNameTextField || textField == lastNameTextField  {
            if helper.isValid(name: firstNameTextField.text!) && helper.isValid(name: lastNameTextField.text!) {
                print("valid Name")
                fullNameContinueButton.isHidden = false
            }else{
                fullNameContinueButton.isHidden = true
            }
        } else if textField == passwordTextField{
            if passwordTextField.text!.count >= 6{
                print("Valid Password")
                passwordContinueButton.isHidden = false
            }else{
                passwordContinueButton.isHidden = true
            }
        }
        
    }
    
    
    
    @IBAction func emailContinueButon_Clicked(_ sender: Any) {
        
        let helper = Helper()
        if helper.isValid(email: emailTextField.text!){
            print("Valid")
        }else{
            print("Invalid")
        }
    }
    
    @IBAction func fullnameContinueButton_clicked(_ sender: Any) {
    }
    
    @IBAction func passwordContinueButon_clicked(_ sender: Any) {
    }
    
    @IBAction func birhdayContinueButton_clicked(_ sender: Any) {
    }
    //Executed once any cancel
    @IBAction func cancelButton_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
