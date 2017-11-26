//
//  AddViewController.swift
//  Contact Book (Stage 1)
//
//  Created by doTZ on 24/11/17.
//  Copyright © 2017 doTZ. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, LocationViewControllerDelegate{
    
    let persistentContainer = AppDelegate.persistentContainer
    
    let viewContext = AppDelegate.viewContext

    let datePicker = UIDatePicker()
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var firstNameTxt : UITextField!
    
    @IBOutlet weak var lastNameTxt : UITextField!
    
    @IBOutlet weak var mobileNumberTxt : UITextField!
    
    @IBOutlet weak var phoneNumberTxt : UITextField!
    
    @IBOutlet weak var emailTxt : UITextField!
    
    @IBOutlet weak var birthdayTxt : UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var locationTxt: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func upload(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Photo Source", message: "Choose your option", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            
            self.present(self.imagePickerController, animated: true, completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.imagePickerController.sourceType = .camera
                
                self.present(self.imagePickerController, animated: true, completion: nil)
                
            } else {
                
                let alertControllerForCamera = UIAlertController(title: "Camera", message: "Sorry not available", preferredStyle: .alert)
                
                alertControllerForCamera.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                
            }
            
        
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func addToContact(_ sender: UIButton) {
        
        guard let firstName = firstNameTxt.text, let mobileNumber = mobileNumberTxt.text, !firstName.isEmpty,
            !mobileNumber.isEmpty
            
        else {
        
            alertInformation(title: "Required Fields", message: "Please enter the required fields to proceed")
            
            return
            
        }
        
        addToCoreData()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Contact"
        
        imagePickerController.delegate = self
        
        firstNameTxt.delegate = self
        
        lastNameTxt.delegate = self
        
        emailTxt.delegate = self
        
        createDatePicker()
        
        changeImageViewToCircular()
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToLocationVC" {
            
            if let locationViewController = segue.destination as? LocationViewController {
                
                locationViewController.delegate = self
                
            }
            
        }
        
    }
    
    func changeImageViewToCircular() {
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
        
        photoImageView.clipsToBounds = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func createDatePicker() {
        
       let toolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.sizeToFit()
        
        toolbar.setItems([doneButton], animated: false)
        
        birthdayTxt.inputAccessoryView = toolbar
        
        birthdayTxt.inputView = datePicker
        
        datePicker.datePickerMode = .date
        
    }
    
    func donePressed() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        
        let dateString = dateFormatter.string(from: datePicker.date)
        
        birthdayTxt.text = dateString
        
        self.view.endEditing(true)
        
    }
    
    func alertInformation(title : String, message : String) {
        
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func addToCoreData() {
        
        let contactObject = ContactBook(context : viewContext)
        
        contactObject.firstName = firstNameTxt.text!
        
        contactObject.lastName = lastNameTxt.text!
        
        contactObject.mobileNumber = Int64(mobileNumberTxt.text!)!
        
        if let phoneNumberTxt = phoneNumberTxt.text, !phoneNumberTxt.isEmpty {
            
            contactObject.phoneNumber = Int64(phoneNumberTxt)!
            
        }
        
        contactObject.email = emailTxt.text!
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let date = dateFormatter.date(from: birthdayTxt.text!) as NSDate?
        
        contactObject.birthday = date
        
        contactObject.currentLocation = locationTxt.text!
        
        if let profileImage = photoImageView.image {
            
            if let imageData = UIImageJPEGRepresentation(profileImage, 1.0) {
                
                contactObject.photo = imageData as NSObject
                
            }
        }
        
        do {
            
            try viewContext.save()
            
            addBtn.isEnabled = false
            
            alertInformation(title: "Saved", message: "Contact has been saved successfully")
            
        } catch {
            
            alertInformation(title: "Error", message: "There was some technical problem")
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            photoImageView.image = image
            
            imagePickerController.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func myLocationAddress(address: String) {
        
        locationTxt.text = address
        
    }
    
}
