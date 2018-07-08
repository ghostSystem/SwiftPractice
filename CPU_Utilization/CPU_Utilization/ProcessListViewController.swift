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
}

class ProcessListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, DataSendDelegate {
    
    var processData = [ProcessDetails]()
    
    @IBOutlet weak var tableView:NSTableView!
    
    var tableViewData = ["Spotify", "Safari"]
    
    var processName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.headerView = nil
        self.tableView.gridStyleMask = .solidHorizontalGridLineMask
        
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        preferredContentSize = NSSize(width: 375, height: 600)
    }
    
    func processData(processName: String, processInterval: String, processDuration: String) {
        
        print("Received Data: PName = \(processName), Interval = \(processInterval), Duration = \(processDuration)")
        
        let dataObject = ProcessDetails(name: processName, interval: processInterval, duration: processDuration)
        processData.append(dataObject)
        
        self.tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return processData.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let result:ProcessTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "defaultRow"), owner: self) as! ProcessTableCellView
        
        let pData = processData[row]
        
        result.processTitle.stringValue = pData.name
        result.processInterval.stringValue = pData.interval
        result.processDuration.stringValue = pData.duration
        
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
