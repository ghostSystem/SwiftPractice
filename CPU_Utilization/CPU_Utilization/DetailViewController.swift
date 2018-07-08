//
//  DetailViewController.swift
//  CPU_Utilization
//
//  Created by Astitv Nagpal on 7/8/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {
    
    
    @IBOutlet weak var processName: NSTextField!
    
    @IBOutlet weak var plotView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        preferredContentSize = NSSize(width: 700, height: 500)
        self.processName.stringValue = self.representedObject as! String
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismissViewController(self)
    }
}
