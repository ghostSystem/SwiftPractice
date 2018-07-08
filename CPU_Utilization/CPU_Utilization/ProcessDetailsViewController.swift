//
//  ProcessDetailsViewController.swift
//  CPU_Utilization
//
//  Created by Astitv Nagpal on 7/8/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import Cocoa

protocol DataSendDelegate {
    func processData(processName: String, processInterval: String, processDuration: String, processId: String)
}

class ProcessDetailsViewController: NSViewController {
    
    var delegate: DataSendDelegate? = nil
    var processId: String = ""
    
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
        if delegate != nil && self.validateProcessAttributes() == true{
            print("Isnide send")
            delegate?.processData(processName: self.processName.stringValue, processInterval: self.processInterval.stringValue, processDuration: self.processDuration.stringValue, processId: self.processId)
            self.dismissViewController(self)
        }
        
    }
    
    func validateProcessAttributes() -> Bool {
        
        if self.processName.stringValue.count == 0 || self.processInterval.stringValue.count == 0 || self.processDuration.stringValue.count == 0 {
            print("Empty Field Error")
            self.dialogOKPrompt(heading: "Field Empty Error !", error: "Fields can't be empty.")
            return false
        }
        
        if self.validateProcessName() == false {
            self.dialogOKPrompt(heading: "Process Name Error !", error: "Please enter the correct process name.")
            return false
        }
        
        if self.validateProcessDuration() == false {
            self.dialogOKPrompt(heading: "Process Duration Error !", error: "Please enter numerical process duration value.")
            return false
        }
        
        if self.validateProcessInterval() == false {
            self.dialogOKPrompt(heading: "Process Interval Error !", error: "Please enter numerical process interval value.")
            return false
        }
        
        return true
        
    }
    
    func validateProcessName() -> Bool {
        
        print("Testing for Process Name = \(self.processName.stringValue)")
        
        let process = Process()
        process.launchPath = "/usr/bin/pgrep"
        
        var arguments: [String] = []
        arguments.append("-x")
        arguments.append(self.processName.stringValue)
        
        process.arguments = arguments
        
        let outPipe = Pipe()
        process.standardOutput = outPipe
        
        process.launch()
        
        let fileHandle = outPipe.fileHandleForReading
        let data = fileHandle.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.ascii.rawValue)! as String
        print("Process PID = \(output)")
        if output.count == 0 {
            print("Process Name Error")
            return false
        }
        self.processId = output
        return true
        
    }
    
    func validateProcessInterval() -> Bool {
        
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self.processInterval.stringValue)) == false {
            print("Process Interval Error")
            return false
        }
        return true
    }
    
    func validateProcessDuration() -> Bool {
        
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self.processDuration.stringValue)) == false {
            print("Process Duration Error")
            return false
        }
        return true
    }
    
    func dialogOKPrompt(heading: String, error: String) {
        let alert = NSAlert()
        alert.messageText = heading
        alert.informativeText = error
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    
}
