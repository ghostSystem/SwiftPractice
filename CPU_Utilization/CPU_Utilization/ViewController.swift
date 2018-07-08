//
//  ViewController.swift
//  CPU_Utilization
//
//  Created by Astitv Nagpal on 7/7/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var processId: String = ""
    
    @IBOutlet weak var processName: NSTextField!
    @IBOutlet weak var processInterval: NSTextField!
    @IBOutlet weak var processDuration: NSTextField!
    
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    @IBOutlet weak var plotView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.progressBar.isHidden = true
        
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func awakeFromNib() {
            let color : CGColor = CGColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
            self.view.layer?.backgroundColor = color
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()

        //preferredContentSize = NSSize(width: 1000, height: 700)
    }
    
    
    @IBAction func computeClicked(_ sender: Any) {
        
        if self.validateProcessAttributes() == false {
            print("Validation Failed...Hence not proceeding !")
            return
        }
        
        print("Validation Success...Hence proceeding !")
        // run the computation
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.startProgressIndicator(duration: Double(self.processDuration.stringValue)!)
            }
            self.startComputation()
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
    
    func startComputation() {
        
        print("Computation Started")
        let process = Process()
        process.launchPath = "/anaconda3/bin/psrecord"
        
        var arguments: [String] = []
        arguments.append(self.processId)
        arguments.append("--log")
        arguments.append("/Users/astitvnagpal/Desktop/activity.log")
        arguments.append("--plot")
        arguments.append("/Users/astitvnagpal/Desktop/plot.png")
        arguments.append("--interval")
        arguments.append(self.processInterval.stringValue)
        arguments.append("--duration")
        arguments.append(self.processDuration.stringValue)
        process.arguments = arguments
        
        process.launch()
        process.waitUntilExit()
        print("Computation Ended")
        
        DispatchQueue.main.async {
            self.renderPlotView()
        }
    }
    
    func renderPlotView() {
        print("activity.log and plot.png are ready")
        self.plotView.imageScaling = .scaleAxesIndependently
        self.plotView.image = NSImage(contentsOfFile: "/Users/astitvnagpal/Desktop/plot.png")
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
    
    
    func startProgressIndicator(duration: Double) {
        
        DispatchQueue.main.async {
            self.progressBar.isHidden = false
        }
        let maxValue = duration
        var startValue = 0.0
        self.progressBar.minValue = startValue
        self.progressBar.maxValue = maxValue
        self.progressBar.isIndeterminate = false
        self.progressBar.usesThreadedAnimation = true
        self.progressBar.isDisplayedWhenStopped = false
        
        DispatchQueue.global(qos: .background).async {
            while startValue != maxValue + 1.0 {
                DispatchQueue.main.async {
                    self.progressBar.doubleValue = startValue
                }
                sleep(1)
                startValue = startValue + 1.0
            }
        }
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

