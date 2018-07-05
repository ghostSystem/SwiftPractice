//
//  ViewController.swift
//  TodoList
//
//  Created by Astitv Nagpal on 7/5/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "authenticationSegue", sender: self)
    }
    

}

