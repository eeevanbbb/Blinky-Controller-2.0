//
//  ManualViewController.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 4/30/16.
//  Copyright © 2016 Evan Bernstein. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupView() {
        for i in 0...Int(view.frame.height) {
            let row = UIView(frame: CGRect(x: 0.0, y: CGFloat(i), width: view.frame.width, height: 1.0))
            row.backgroundColor = UIColor(hue: CGFloat(i) / view.frame.height, saturation: 1, brightness: 1, alpha: 1)
            view.addSubview(row)
        }
        
        for i in 0...150 {
            let x = view.frame.width * (CGFloat(i) / 150)
            let column = UIView(frame: CGRect(x: x, y: 0, width: 1, height: view.frame.height))
            column.backgroundColor = UIColor.blackColor()
            view.addSubview(column)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func positionToIndexAndColor(position: CGPoint) -> (Int, UIColor) {
        let index = Int((position.x / view.frame.width) * 150)
        let color = UIColor(hue: (position.y / view.frame.height), saturation: 1, brightness: 1, alpha: 1)
        return (index,color)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let (index, color) = positionToIndexAndColor(touch.locationInView(view))
            HTTPRequestHandler.sharedInstance.sendManualCommand(index, color: color, completion: {
                error in
                if error != nil {
                    print("Error sending manual command: \(error!.description)")
                }
            })
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let (index, color) = positionToIndexAndColor(touch.locationInView(view))
            HTTPRequestHandler.sharedInstance.sendManualCommand(index, color: color, completion: {
                error in
                if error != nil {
                    print("Error sending manual command: \(error!.description)")
                }
            })
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        HTTPRequestHandler.sharedInstance.sendManualCommand(-1, color: UIColor.blackColor(), completion: {
            error in
            if error != nil {
                print("Error sending manual command: \(error!.description)")
            }
        })
    }

}
