//
//  ViewController.swift
//  CPU_Utilization
//
//  Created by Astitv Nagpal on 7/7/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Started")
        var arguments: [String] = []
        arguments.append("94702")
        arguments.append("--log")
        arguments.append("/Users/astitvnagpal/activity.txt")
        arguments.append("--plot")
        arguments.append("/Users/astitvnagpal/plot.png")
        arguments.append("--interval")
        arguments.append("1")
        arguments.append("--duration")
        arguments.append("10")
        
        let process = Process()
        process.launchPath = "/anaconda3/bin/psrecord"
        process.arguments = arguments
        
        //process.launch()
        //process.waitUntilExit()
        print("Ended")
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()

        preferredContentSize = NSSize(width: 1000, height: 700)
    }
    
    
    @IBAction func computeClicked(_ sender: Any) {
        
        let indicator = NSProgressIndicator(frame: NSRect(x: 43, y: 632, width: 924, height: 20))
        indicator.minValue = 0.0
        indicator.maxValue = 10.0
        indicator.isIndeterminate = false
        self.view.addSubview(indicator)
        var a = 0.0
        DispatchQueue.global(qos: .background).async {
        for _ in 1...11 {
            DispatchQueue.main.async {
            indicator.doubleValue = a
            }
            sleep(1)
            a = a+1.0
            }
        }
        
        
    }
    

}

