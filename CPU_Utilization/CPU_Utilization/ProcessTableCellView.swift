//
//  ProcessTableCellView.swift
//  CPU_Utilization
//
//  Created by Astitv Nagpal on 7/8/18.
//  Copyright © 2018 ghost_system. All rights reserved.
//

import Cocoa

class ProcessTableCellView: NSTableCellView {
    
    
    @IBOutlet weak var processTitle: NSTextField!
    
    @IBOutlet weak var processInterval: NSTextField!
    
    @IBOutlet weak var processDuration: NSTextField!
    @IBOutlet weak var processCPUPercentage: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
