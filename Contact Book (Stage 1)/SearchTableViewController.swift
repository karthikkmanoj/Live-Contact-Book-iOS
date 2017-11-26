//
//  SearchTableViewController.swift
//  Contact Book (Stage 1)
//
//  Created by doTZ on 25/11/17.
//  Copyright © 2017 doTZ. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UITextFieldDelegate {
    
    let persistentContainer = AppDelegate.persistentContainer
    
    let viewContext = AppDelegate.viewContext
    
    var contactBookArray = [ContactBook]()
    
    var searchText : String? {
        
        didSet {

            if (searchText?.isEmpty)! {
                
                retrieveDataFromCoreData()
                
            } else {
                
                if let firstCharacter = searchText?.characters[(searchText?.characters.startIndex)!] {
                
                    contactBookArray.removeAll()
                    
                    retrieveDataFromCoreData(searchTextForPredicate: searchText, firstCharacter: String(firstCharacter))
                    
                }
                
            }
            
        }
    
    }
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Wipe Off" , message: "Do you want to do this?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            self.deleteAllFromCoreData()
            
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
     
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        
        didSet {
            
            searchTextField.delegate = self
            
       }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Search Contact"
        
        retrieveDataFromCoreData()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        retrieveDataFromCoreData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == searchTextField {
            
            let trimmedString = searchTextField.text?.trimmingCharacters(in: .whitespaces)
            
            searchText = trimmedString
            
        }
        
        return  true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func alertInformation(title : String, message : String) {
        
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func retrieveDataFromCoreData(searchTextForPredicate : String? = nil, firstCharacter : String? = nil) {

        let request : NSFetchRequest<ContactBook> = ContactBook.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        if searchTextForPredicate != nil {
            
            
            let predicateOne = NSPredicate(format: "firstName =[c] %@", searchTextForPredicate!)
            
            let predicateTwo = NSPredicate(format: "any firstName beginswith[c] %@", firstCharacter!)
            
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateOne,predicateTwo])
            
            request.predicate = predicate
            
        }

        do {

            let result  = try viewContext.fetch(request)
                
            contactBookArray = result
            
            tableView.reloadData()
                
        } catch {
            
            alertInformation(title: "Error", message: "Could not load database")
        }
        
    }
    
    func deleteAllFromCoreData() {
        
        let request : NSFetchRequest<ContactBook> = ContactBook.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            
            try viewContext.execute(deleteRequest)
            
            retrieveDataFromCoreData()
            
            alertInformation(title: "Contact Book Wiped Off!", message: "")
            
        } catch {
            
            alertInformation(title: "Error", message: "Could not process your request")
            
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contactBookArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
             let contactObject = contactBookArray[indexPath.row]
            
            viewContext.delete(contactObject)
                
            do {
                    
                try viewContext.save()
                    
                retrieveDataFromCoreData()
                    
            } catch {
                    
                alertInformation(title: "Error", message: "Could not proccess your request")
            }
                
        }
            
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let detailedContactController = storyBoard.instantiateViewController(withIdentifier: "DetailedContactController") as! DetailedContactViewController
        
        self.navigationController?.pushViewController(detailedContactController, animated: true)
        
        detailedContactController.contactObject = contactBookArray[indexPath.row]
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactInfoCell", for: indexPath)
        
        if let contactCell = cell as? ContactTableViewCell {
            
            contactCell.nameLabel.text = contactBookArray[indexPath.row].firstName
            
            contactCell.mobileNumberLabel.text = String(contactBookArray[indexPath.row].mobileNumber)
            
            contactCell.phoneNumberLabel.text = String(contactBookArray[indexPath.row].phoneNumber)
            
            if let imageData = contactBookArray[indexPath.row].photo as? Data {
                
                if let image = UIImage(data: imageData) {
                    
                    contactCell.photoImageView.image = image
                    
                }
                
            }
            
            return contactCell
            
        }
        
        return cell
        
    }
    
}
