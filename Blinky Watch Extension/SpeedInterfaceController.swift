//
//  SpeedInterfaceController.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import WatchKit
import Foundation


class SpeedInterfaceController: WKInterfaceController {
    
    @IBOutlet var speedSlider: WKInterfaceSlider?
    @IBOutlet var speedLabel: WKInterfaceLabel?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        refreshState()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    func refreshState() {
        HTTPRequestHandler.sharedInstance.refreshState({
            error in
            if (error != nil) {
                print("Error refreshing state: %@",error)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.speedSlider?.setValue(HTTPRequestHandler.sharedInstance.speed)
                    self.speedLabel?.setText("Speed: "+String(Int(HTTPRequestHandler.sharedInstance.speed)))
                })
            }
        })
    }
    
    
    @IBAction func sliderValueChanged(value: Float) {
        speedLabel?.setText("Speed: "+String(Int(value)));
        HTTPRequestHandler.sharedInstance.sendSpeed(Double(value), completion: {
            _data in
            //Do stuff
        })
    }

}
