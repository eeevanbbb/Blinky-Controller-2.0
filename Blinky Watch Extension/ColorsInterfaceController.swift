//
//  ColorsInterfaceController.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import WatchKit
import Foundation


class ColorsInterfaceController: WKInterfaceController {
    
    var red: Float = 255
    var green: Float = 0
    var blue: Float = 0
    
    @IBOutlet var redSlider: WKInterfaceSlider?
    @IBOutlet var greenSlider: WKInterfaceSlider?
    @IBOutlet var blueSlider: WKInterfaceSlider?
    
    @IBOutlet var colorLabel: WKInterfaceLabel?

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
    
    
    @IBAction func redSliderChangedValue(value: Float) {
        red = value;
        updateColorString()
        sendColor()
    }
    
    @IBAction func greenSliderChangedValue(value: Float) {
        green = value;
        updateColorString()
        sendColor()
    }
    
    @IBAction func blueSliderChangedValue(value: Float) {
        blue = value;
        updateColorString()
        sendColor()
    }
    
    func sendColor() {
        HTTPRequestHandler.sharedInstance.sendColor(UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1), completion: {
            _data in
            //Do stuff
        })
    }
    
    
    func updateColorString() {
        colorLabel?.setText(String(Int(red))+","+String(Int(green))+","+String(Int(blue)))
    }

}
