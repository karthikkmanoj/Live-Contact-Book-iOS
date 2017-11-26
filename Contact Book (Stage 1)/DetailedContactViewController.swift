//
//  DetailedContactViewController.swift
//  Contact Book (Stage 1)
//
//  Created by doTZ on 25/11/17.
//  Copyright © 2017 doTZ. All rights reserved.
//

import UIKit

class DetailedContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationViewControllerDelegate {
    
    let persistentContainer = AppDelegate.persistentContainer
    
    let viewContext = AppDelegate.viewContext
    
    var contactObject : ContactBook?
    
    let datePicker = UIDatePicker()
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var firstNameLbl : UILabel!
    
    @IBOutlet weak var lastNameLbl : UILabel!
    
    @IBOutlet weak var mobileNumberLbl : UILabel!
    
    @IBOutlet weak var phoneNumberLbl : UILabel!
    
    @IBOutlet weak var emailLbl : UILabel!
    
    @IBOutlet weak var birthdayTxtField: UITextField!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!

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
    
    @IBAction func changeBirthday(_ sender: UIButton) {
        
        
        let dateFormatter = DateFormatter()
            
        dateFormatter.dateFormat = "MMM dd, yyyy"
            
        let date = dateFormatter.date(from: birthdayTxtField.text!) as NSDate?
            
        contactObject?.birthday = date
            
        saveInstantly()
            
        let alertController = UIAlertController(title: "Update", message: "Updated Successfully", preferredStyle: .alert)
            
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
        self.present(alertController, animated: true, completion: nil)
            
    }
    
    @IBAction func updateCoreData(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 1 : alertControllerToUpdate(label: firstNameLbl, tag : sender.tag)
        
        case 2 : alertControllerToUpdate(label: lastNameLbl, tag : sender.tag)
        
        case 3 : alertControllerToUpdate(label: mobileNumberLbl, tag : sender.tag)
        
        case 4 : alertControllerToUpdate(label: phoneNumberLbl, tag : sender.tag)
        
        case 5 : alertControllerToUpdate(label: emailLbl, tag : sender.tag)
        
        default : break
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = contactObject?.firstName
        
        imagePickerController.delegate = self
        
        changeImageViewToCircular()
        
        displayDetails()
        
        createDatePicker()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueFromDetailedToLocation" {
            
            if let locationViewController = segue.destination as? LocationViewController {
                
                locationViewController.delegate = self
                
            }
            
        }
        
    }
    
    func changeImageViewToCircular() {
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
        
        photoImageView.clipsToBounds = true
        
    }
    
    func createDatePicker() {
        
        let toolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.sizeToFit()
        
        toolbar.setItems([doneButton], animated: false)
        
        birthdayTxtField.inputAccessoryView = toolbar
        
        birthdayTxtField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        
    }
    
    func donePressed() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dateFormatter.timeStyle = .none
        
        let dateString = dateFormatter.string(from: datePicker.date)
        
        birthdayTxtField.text = dateString
        
        self.view.endEditing(true)
        
    }
    
    func saveInstantly() {
    
        do {
            
            try viewContext.save()
            
            print("Record has been Saved Successfully")
            
        } catch {
            
            print("Error Updating")
            
        }
        
    }
    
    func alertControllerToUpdate(label : UILabel, tag : Int) {
        
        let alertController = UIAlertController(title: "Update", message: "Please Enter to Update", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            
            if let textField = alertController.textFields {
                
                      switch tag {
                    
                       case 1 : self.contactObject?.firstName = textField[0].text!
                        
                                label.text = textField[0].text
                        
                                self.saveInstantly()
                        
                       case 2 : self.contactObject?.lastName = label.text!
                        
                                label.text = textField[0].text
                        
                                self.saveInstantly()
                        
                       case 3 : if (Int64(textField[0].text!) != nil) {
                        
                                    self.contactObject?.mobileNumber = Int64(textField[0].text!)!
                        
                                    label.text = textField[0].text
                        
                                    self.saveInstantly()
                        
                                }
                        
                       case 4 : if (Int64(textField[0].text!) != nil) {
                        
                                    self.contactObject?.phoneNumber = Int64(textField[0].text!)!
                        
                                    label.text = textField[0].text
                        
                                    self.saveInstantly()

                                }
                        
                      case 5 : self.contactObject?.email = textField[0].text!
                        
                               label.text = textField[0].text
                        
                               self.saveInstantly()
                        
                        
                      default : break
                        
                }
                
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        alertController.addTextField { (textField) in
            
            textField.placeholder = "Enter the item to update"
            
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    func displayDetails() {
        
        firstNameLbl.text = contactObject?.firstName
        
        if let lastName = contactObject?.lastName {
        
            lastNameLbl.text = lastName
            
        }
            
        if let mobileNumber = contactObject?.mobileNumber {
            
            mobileNumberLbl.text = String(mobileNumber)
            
        }
        
        if let phoneNumber = contactObject?.phoneNumber {
            
            phoneNumberLbl.text = String(phoneNumber)
            
        }
        
        if let email = contactObject?.email {
            
            emailLbl.text = email
            
        }
        
        if let email = contactObject?.email {
            
            emailLbl.text = email
            
        }
        
        if let location = contactObject?.currentLocation {
            
            locationLbl.text = location
            
        }
    
      if let birthday = contactObject?.birthday {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let dateString = dateFormatter.string(from: birthday as Date)

        birthdayTxtField.text = dateString
        
       }
        
      if let imageData = contactObject?.photo as? Data {
        
            if let image = UIImage(data: imageData) {
                
            photoImageView.image = image
                
            }
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            photoImageView.image = image
        
            if let profileImage = photoImageView.image {
                
                if let imageData = UIImageJPEGRepresentation(profileImage, 1.0) {
                    
                    contactObject?.photo = imageData as NSObject
                    
                    saveInstantly()
                    
                }
            }
            
            imagePickerController.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    
    func myLocationAddress(address: String) {
        
        contactObject?.currentLocation = address
        
        locationLbl.text = address
        
        saveInstantly()

    }

}
