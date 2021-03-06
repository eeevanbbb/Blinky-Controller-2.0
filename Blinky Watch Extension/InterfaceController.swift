//
//  InterfaceController.swift
//  Blinky Watch Extension
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var commands = [String]()
    var chosenCommandIndex = 0

    @IBOutlet var commandPicker: WKInterfacePicker!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        HTTPRequestHandler.sharedInstance.getListOfCommands({
            _commands in
            dispatch_async(dispatch_get_main_queue(), {
                if _commands.count > 0 {
                    self.commands = _commands
                    var items = [WKPickerItem]()
                    for command in self.commands {
                        let item = WKPickerItem()
                        item.title = command
                        items.append(item)
                    }
                    self.commandPicker.setItems(items)
                    self.refreshState()
                }
            })
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func refreshState() {
        HTTPRequestHandler.sharedInstance.refreshState({
            error in
            if error != nil {
                print("Error refreshing state")
            } else {
                let command = HTTPRequestHandler.sharedInstance.command
                let index = self.commands.indexOf(command)
                dispatch_async(dispatch_get_main_queue(), {
                    self.commandPicker.setSelectedItemIndex(index!)
                })
            }
        })
    }

    @IBAction func itemPickerUpdated(index: Int) {
        chosenCommandIndex = index
    }
    
//    override func pickerDidSettle(picker: WKInterfacePicker) {
//        HTTPRequestHandler.sharedInstance.sendCommand(commands[chosenCommandIndex], completion: {
//            data in
//            //Do stuff?
//        })
//    }
    
    @IBAction func sendCommand() {
        HTTPRequestHandler.sharedInstance.sendCommand(commands[chosenCommandIndex], completion: {
            data in
            //Do stuff?
        })
    }
}
