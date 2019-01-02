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
    
    
    
    @IBOutlet weak var scrolView: UIScrollView!
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
    var datePicker: UIDatePicker!
    
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
        
        //implement datePicker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -5 ,to: Date())
        datePicker.addTarget(self, action: #selector(self.datePickerChange(_:)), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        
        
        //implementation of Swipe Gesture
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handle(_:)))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
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
        
        // move scrollView horizontally
        let position = CGPoint(x: self.view.frame.width, y: 0)
        scrolView.setContentOffset(position, animated: true)
        
        // show keyboard of next TextFideld
        if firstNameTextField.text!.isEmpty{
            firstNameTextField.becomeFirstResponder()
        }else if lastNameTextField.text!.isEmpty {
            lastNameTextField.becomeFirstResponder()
        } else if firstNameTextField.text!.isEmpty == false && lastNameTextField.text!.isEmpty == false {
            firstNameTextField.resignFirstResponder()
            lastNameTextField.resignFirstResponder()
        }
        
    }
    
    @IBAction func fullnameContinueButton_clicked(_ sender: Any) {
        
        // move scrollView horizontally
        let position = CGPoint(x: self.view.frame.width * 2, y: 0)
        scrolView.setContentOffset(position, animated: true)
        
        // show keyboard of next TextFideld
        if passwordTextField.text!.isEmpty{
            passwordTextField.becomeFirstResponder()
        }else if passwordTextField.text!.isEmpty == false{
            passwordTextField.resignFirstResponder()
        }
        
    }
    
    @IBAction func passwordContinueButon_clicked(_ sender: Any) {
        // move scrollView horizontally
        let position = CGPoint(x: self.view.frame.width * 3, y: 0)
        scrolView.setContentOffset(position, animated: true)
        
        // show keyboard of next TextFideld
        if birthdayTextField.text!.isEmpty{
            birthdayTextField.becomeFirstResponder()
        }else if birthdayTextField.text!.isEmpty == false{
            birthdayTextField.resignFirstResponder()
        }
        
    }
    
    @objc func datePickerChange(_ datePicker: UIDatePicker){
        
        let formater = DateFormatter()
        formater.dateStyle = DateFormatter.Style.medium
        birthdayTextField.text = formater.string(from: datePicker.date)
        
        let compareDateFormater = DateFormatter()
        compareDateFormater.dateFormat = "yyyy/MM/dd HH:mm"
        
        let compareDate = compareDateFormater.date(from: "2013/01/01 00:01")
        
        if datePicker.date < compareDate!{
            birthdayContinueButton.isHidden = false
        }else{
            birthdayContinueButton.isHidden = true
        }
        
    }
    
    @IBAction func birhdayContinueButton_clicked(_ sender: Any) {
        
        // move scrollView horizontally
        let position = CGPoint(x: self.view.frame.width * 4, y: 0)
        scrolView.setContentOffset(position, animated: true)
        
        // hide keyboard
        birthdayTextField.resignFirstResponder()
        
    }
    
    @objc func handle(_ gesture: UISwipeGestureRecognizer){
        
        
        // gwtting current position of the ScrollView
        let current_x = scrolView.contentOffset.x
        let new_x = CGPoint(x: current_x - self.view.frame.width, y: 0)
        
        if current_x > 0 {
            scrolView.setContentOffset(new_x, animated: true)
        }
        
    }
    
    @IBAction func genderButton_clicked(_ sender: Any) {
        
        let url = URL(string: "localhost/fb/register.php")
        var gender = ""
        if (sender as AnyObject).tag == 0{
            print("Female")
            gender = "female"
        }else{
            print("Male")
            gender = "male"
        }
        let body = "email=\(emailTextField.text!.lowercased())&firstName=\(firstNameTextField.text!.lowercased())&lastName=\(lastNameTextField.text!.lowercased())&password=\(passwordTextField.text!)&birthday=\(datePicker.date)&gender=\(gender)"
        
        var request = URLRequest(url: url!)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                        helper.showAlert(title: "Error", message: message, from: self)
                    }
                }
                
                print(parsedJSON)
                // error while
            } catch {
                helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
            }
            
            
        }.resume()
        
    }
    
    
    //Executed once any cancel
    @IBAction func cancelButton_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
