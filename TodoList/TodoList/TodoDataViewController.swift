//
//  TodoDataViewController.swift
//  TodoList
//
//  Created by Astitv Nagpal on 7/5/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import UIKit

class TodoDataViewController: UIViewController {

    @IBOutlet weak var todoDetails: UILabel!
    var passedValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.todoDetails.text = self.passedValue
        
    }

}
