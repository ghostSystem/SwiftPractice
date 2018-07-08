//
//  ProcessDetailsViewController.swift
//  CPU_Utilization
//
//  Created by Astitv Nagpal on 7/8/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import Cocoa

protocol DataSendDelegate {
    func processData(processName: String, processInterval: String, processDuration: String)
}

class ProcessDetailsViewController: NSViewController {
    
    var delegate: DataSendDelegate? = nil
    
    @IBOutlet weak var processInterval: NSTextField!
    @IBOutlet weak var processDuration: NSTextField!
    @IBOutlet weak var processName: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        preferredContentSize = NSSize(width: 375, height: 230)
    }
        
    
    @IBAction func saveProcessClicked(_ sender: Any) {
        // do other conditional checks as well
        if delegate != nil {
            print("Isnide send")
            delegate?.processData(processName: self.processName.stringValue, processInterval: self.processInterval.stringValue, processDuration: self.processDuration.stringValue)
        }
        
        self.dismissViewController(self)
    }
    
    
}
