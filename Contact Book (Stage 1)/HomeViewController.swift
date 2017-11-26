//
//  ViewController.swift
//  Contact Book (Stage 1)
//
//  Created by doTZ on 24/11/17.
//  Copyright © 2017 doTZ. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var addContactBtn: UIButton!
    
    @IBOutlet weak var searchContactBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
    }
    
}

