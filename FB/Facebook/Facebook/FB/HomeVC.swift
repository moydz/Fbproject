//
//  HomeVC.swift
//  FaceBook
//
//  Created by MacBook Pro on 4/5/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class HomeVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // ui obj
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var addBioButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    
    
    
    
    // code obj (to build logic of distinguishing tapped / shown Cover / Ava)
    var isCover = false
    var isAva = false
    var imageViewTapped = ""
    
    
    
    // first load func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add observers for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(loadUser), name: NSNotification.Name(rawValue: "updateBio"), object: nil)
        
        // run funcs
        configure_avaImageView()
        loadUser()
    }
    
    // loads all user related information to be shiown in the header
    @objc func loadUser(){
        
        // safe method of accessing user related information in glob user 
        guard let firstName = currentUser?["firstName"],
              let lastName = currentUser?["lastName"],
              let avaPath = currentUser?["ava"],
              let coverPath = currentUser?["cover"],
              let bio = currentUser?["bio"] else
        {
            return
        }
        
        // assigning vars which ws accessed fro global var , to fullnameLabel
        fullnameLabel.text = "\((firstName as! String).capitalized) \((lastName as! String).capitalized)"
        
        // downloading the images and assigning to certain imageview
        Helper().downloadImage(from: avaPath as! String, showIn: avaImageView, orShow: "user.png")
        Helper().downloadImage(from: coverPath as! String, showIn: coverImageView, orShow: "HomeCover.jpg")
        
        // if bio is Emty in the server --> hide bio label , otherwise , show bio label
        if (bio as! String).isEmpty{
            bioLabel.isHidden = true
            addBioButton.isHidden = false
        }else{
            bioLabel.text = "\(bio)"
            bioLabel.isHidden = false
            addBioButton.isHidden = true
        }
        
    }
    
    

    
    // configuring the appearance of AvaImageView
    func configure_avaImageView() {
        
        // creating layer that will be applied to avaImageView (layer - broders of ava)
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = 5
        border.frame = CGRect(x: 0, y: 0, width: avaImageView.frame.width, height: avaImageView.frame.height)
        avaImageView.layer.addSublayer(border)
        
        // rounded corners
        avaImageView.layer.cornerRadius = 10
        avaImageView.layer.masksToBounds = true
        avaImageView.clipsToBounds = true
    }
    
    
    // takes us to the PickerController (Controller that allows us to select picture)
    func showPicker(with source: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
        
    }
    
    
    // executed when Cover is tapped
    @IBAction func coverImageView_tapped(_ sender: Any) {
        
        // switching trigger
        imageViewTapped = "cover"
        
        // launch action sheet calling function
        showActionSheet()
    }
    
    
    // executed when Ava is tapped
    @IBAction func avaImageView_tapped(_ sender: Any) {
        
        // switching trigger
        imageViewTapped = "ava"
        
        // launch action sheet calling function
        showActionSheet()
    }
    
    
    // this function launches Action Sheet for the photos
    func showActionSheet() {
        
        // declaring action sheet
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        // declaring camera button
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            // if camera available on device, than show
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(with: .camera)
            }
            
        }
        
        
        // declaring library button
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            // checking availability of photo library
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.showPicker(with: .photoLibrary)
            }
            
        }
        
        
        // declaring cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // declaring delete button
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            // deleting profile picture (ava), by returning placeholder
            if self.imageViewTapped == "ava" {
                self.avaImageView.image = UIImage(named: "user.png")
                self.isAva = false
            } else if self.imageViewTapped == "cover" {
                self.coverImageView.image = UIImage(named: "HomeCover.jpg")
                self.isCover = false
            }
            
        }
        
        
        // manipulating appearance of delete button for each scenarios
        if imageViewTapped == "ava" && isAva == false {
            delete.isEnabled = false
        } else if imageViewTapped == "cover" && isCover == false {
            delete.isEnabled = false
        }
        
        
        // adding buttons to the sheet
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        sheet.addAction(delete)
        
        // present action sheet to the user finally
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    // executed once the picture is selected in PickerController
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // access image selected from pickerController
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        // based on the trigger we are assigning selected pictures to the appropriated imageView
        if imageViewTapped == "cover" {
            
            // assign selected image to CoverImageView
            self.coverImageView.image = image
            
            // upload image to the server
            self.uploadImage(from: self.coverImageView)
            
        } else if imageViewTapped == "ava" {
            
            // assign selected image to AvaImageView
            self.avaImageView.image = image
            
            // upload image to the server
            self.uploadImage(from: avaImageView)
            
        }
        
        // completion handler, to communicate to the project that images has been selected (enable delete button)
        dismiss(animated: true) {
            if self.imageViewTapped == "cover" {
                self.isCover = true
            } else if self.imageViewTapped == "ava" {
                self.isAva = true
            }
        }
        
    }
    
    
    // sends request to the server to upload the Image (ava/cover)
    func uploadImage(from imageView: UIImageView) {
        
        // save method of accessing ID of current user
        guard let id = currentUser?["id"] else {
            return
        }
        
        // STEP 1. Declare URL, Request and Params
        // url we gonna access (API)
        let server = Helper().getUrlServer()
        let url = URL(string: "\(server)fb/uploadImage.php")!
        
        // declaring reqeust with further configs
        var request = URLRequest(url: url)
        
        // POST - safest method of passing data to the server
        request.httpMethod = "POST"
        
        // values to be sent to the server under keys (e.g. ID, TYPE)
        let params = ["id": id, "type": imageViewTapped]
        
        // MIME Boundary, Header
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // if in the imageView is placeholder - send no picture to the server
        // Compressing image and converting image to 'Data' type
        var imageData = Data()
        
        if imageView.image != UIImage(named: "HomeCover.jpg") && imageView.image != UIImage(named: "user.png") {
            imageData = imageView.image!.jpegData(compressionQuality: 0.5)!
        }
        
        // assigning full body to the request to be sent to the server
        request.httpBody = Helper().body(with: params, filename: "\(imageViewTapped).jpg", filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                // error occured
                if error != nil {
                    Helper().showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    return
                }
                
                
                do {
                    
                    // save mode of casting any data
                    guard let data = data else {
                        Helper().showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                        return
                    }
                    
                    // fetching JSON generated by the server - php file
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJSON = json else {
                        return
                    }
                    
                    // upload successfully
                    if parsedJSON["status"] as! String == "200" {
                        
                        // saving update user related information
                        currentUser = parsedJSON.mutableCopy() as? NSMutableDictionary
                        UserDefaults.standard.set(currentUser, forKey: "currentUser")
                        UserDefaults.standard.synchronize()
                        
                        // error uploadping
                    } else {
                        // show the error message
                        if parsedJSON["message"] != nil {
                            let message = parsedJSON["message"] as! String
                            Helper().showAlert(title: "Error", message: message, from: self)
                        }
                        
                    }
                    
                } catch {
                    Helper().showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                }
                
            }
            }.resume()
        
        
    }
    
    
    // execute when add bio
    @IBAction func addButton_clicked(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BioVC")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func postButton_clicked(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postVC")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    // execute when bio label has been tapped
    @IBAction func bioLabel_tapped(_ sender: Any) {
        
        // declaring action sheet
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        // declaring bio button
        let bio = UIAlertAction(title: "New Bio", style: .default) { (action) in
           let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BioVC")
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        
        
        // declaring cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // declaring delete button
        let delete = UIAlertAction(title: "Delete Bio", style: .destructive) { (action) in
            
            self.updateBio()
        }
        
        // adding buttons to the sheet
        sheet.addAction(bio)
        sheet.addAction(cancel)
        sheet.addAction(delete)
        
        // present action sheet to the user finally
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    // deleting bio by sending reuest to the sever
    func updateBio(){
        
        guard  let id = currentUser?["id"]
            else{
                return
        }
        let bio = ""
        
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
                        
                        // reload user
                        self.loadUser()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}

