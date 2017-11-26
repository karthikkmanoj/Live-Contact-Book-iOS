//
//  ContactTableViewCell.swift
//  Contact Book (Stage 1)
//
//  Created by doTZ on 25/11/17.
//  Copyright © 2017 doTZ. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        changeImageViewToCircular()
        
    }

    func changeImageViewToCircular() {
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
        
        photoImageView.clipsToBounds = true
        
    }
    
}
