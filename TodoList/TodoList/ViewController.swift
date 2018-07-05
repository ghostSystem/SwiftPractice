//
//  ViewController.swift
//  TodoList
//
//  Created by Astitv Nagpal on 7/5/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordtextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Authentication Error", message: "Invalid Credentials", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        if(usernameTextField.text == "astitv" && passwordtextField.text == "astitv") {
            self.performSegue(withIdentifier: "authenticationSegue", sender: self)
        }
        else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}

