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
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func sliderValueChanged(value: Float) {
        speedLabel?.setText("Speed: "+String(Int(value)));
        HTTPRequestHandler.sharedInstance.sendSpeed(Double(value), completion: {
            _data in
            //Do stuff
        })
    }

}
