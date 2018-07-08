//
//  ProcessListViewController.swift
//  CPU_Utilization
//
//  Created by Astitv Nagpal on 7/8/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import Cocoa

struct ProcessDetails {
    var name: String!
    var interval: String!
    var duration: String!
    var processId: String!
}

class ProcessListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, DataSendDelegate {
    
    var processData = [ProcessDetails]()
    
    @IBOutlet weak var tableView:NSTableView!
        
    
    var processName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.headerView = nil
        self.tableView.gridStyleMask = .solidHorizontalGridLineMask
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        preferredContentSize = NSSize(width: 375, height: 600)
    }
    
    func processData(processName: String, processInterval: String, processDuration: String, processId: String) {
        
        print("Received Data: PName = \(processName), Interval = \(processInterval), Duration = \(processDuration), processId = \(processId)")
        
        let dataObject = ProcessDetails(name: processName, interval: processInterval, duration: processDuration, processId: processId)
        processData.append(dataObject)
        self.tableView.reloadData(forRowIndexes: [self.processData.count], columnIndexes: [0])
        //self.tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.processData.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let result:ProcessTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "defaultRow"), owner: self) as! ProcessTableCellView
        
        let pData = processData[row]
        
        result.processTitle.stringValue = pData.name
        result.processInterval.stringValue = pData.interval
        result.processDuration.stringValue = pData.duration
        result.processID.stringValue = pData.processId
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                // Setting up the Progress Bar
                var startValue = 0.0
                let maxValue = Double(pData.duration)!
                result.progressBar.minValue = startValue
                result.progressBar.maxValue = Double(pData.duration)!
                result.progressBar.isIndeterminate = false
                DispatchQueue.global(qos: .background).async {
                    while startValue != maxValue + 1.0 {
                        DispatchQueue.main.async {
                            result.progressBar.doubleValue = startValue
                        }
                        sleep(1)
                        startValue = startValue + 1.0
                    }
                }
            }
            self.startComputation(processId: pData.processId, processInterval: pData.interval, processDuration: pData.duration)
        }
        
        return result
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let myTable = notification.object as? NSTableView {
            
            //let selected = myTable.selectedRowIndexes.map { Int($0) }
            let selected = myTable.selectedRow
            print("The row selected was \(selected)")
            if selected >= 0 {
                let pData = processData[selected]
                self.processName = pData.name
                self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "viewPlot"), sender: self)
            }
        }
    }
    
    
    func startComputation(processId: String, processInterval: String, processDuration: String) {
        
        print("Computation Started")
        let process = Process()
        process.launchPath = "/anaconda3/bin/psrecord"
        var arguments: [String] = []
        arguments.append(processId)
        arguments.append("--log")
        arguments.append("/Users/astitvnagpal/Desktop/activity.log")
        arguments.append("--plot")
        arguments.append("/Users/astitvnagpal/Desktop/plot.png")
        arguments.append("--interval")
        arguments.append(processInterval)
        arguments.append("--duration")
        arguments.append(processDuration)
        process.arguments = arguments
        
        process.launch()
        process.waitUntilExit()
        print("Computation Ended")
        
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier!.rawValue == "viewPlot" {
            let detailViewController = segue.destinationController as! DetailViewController
            detailViewController.representedObject = self.processName
        }
        
        else if segue.identifier!.rawValue == "processDetails" {
            let processDetailViewController = segue.destinationController as! ProcessDetailsViewController
            processDetailViewController.delegate = self
        }
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return MyRowView()
    }
    
    
    @IBAction func addProcessClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "processDetails"), sender: self)
    }
        
    
}

class MyRowView: NSTableRowView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if isSelected == true {
            NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).set()
            dirtyRect.fill()
        }
    }
}
