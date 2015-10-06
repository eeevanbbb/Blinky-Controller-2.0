//
//  SpeedAndColorViewController.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import UIKit
import WebKit

class SpeedAndColorViewController: UIViewController {
    
    @IBOutlet var colorBox: UIView!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var speedSlider: UISlider!
    @IBOutlet var speedLabel: UILabel!
    
    var webViewPresent = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateColor() {
        let color = UIColor(red: CGFloat(redSlider.value)/255.0, green: CGFloat(greenSlider.value)/255.0, blue: CGFloat(blueSlider.value)/255.0, alpha: 1.0)
        colorBox.backgroundColor = color
        redLabel.text = String(redSlider.value)
        greenLabel.text = String(greenSlider.value)
        blueLabel.text = String(blueSlider.value)
        
        HTTPRequestHandler.sharedInstance.sendColor(color, completion: {
            data in
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil {
                    if self.webViewPresent == false {
                        let webView = WKWebView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 100))
                        if let HTMLString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                            webView.loadHTMLString(HTMLString as String, baseURL: nil)
                            self.webViewPresent = true
                            UIView.animateWithDuration(0.5, animations: {
                                webView.frame = CGRectMake(webView.frame.origin.x, self.view.frame.height-webView.frame.height, self.view.frame.width, webView.frame.height)
                            })
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                                self.webViewPresent = false
                                UIView.animateWithDuration(0.5, animations: {
                                    webView.frame = CGRectMake(webView.frame.origin.x, self.view.frame.height, self.view.frame.width, webView.frame.height)
                                    }, completion: {
                                        _ in
                                        webView.removeFromSuperview()
                                })
                            });
                        } else {
                            print("Could not parse response data")
                        }
                    }
                } else {
                    print("Response data is nil")
                }
            })
        })
    }
    
    func updateSpeed() {
        let speed = Double(speedSlider.value)
        speedLabel.text = String(speed)
        
        HTTPRequestHandler.sharedInstance.sendSpeed(speed, completion: {
            data in
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil {
                    if self.webViewPresent == false {
                        let webView = WKWebView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 100))
                        if let HTMLString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                            webView.loadHTMLString(HTMLString as String, baseURL: nil)
                            self.webViewPresent = true
                            UIView.animateWithDuration(0.5, animations: {
                                webView.frame = CGRectMake(webView.frame.origin.x, self.view.frame.height-webView.frame.height, self.view.frame.width, webView.frame.height)
                            })
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                                self.webViewPresent = false
                                UIView.animateWithDuration(0.5, animations: {
                                    webView.frame = CGRectMake(webView.frame.origin.x, self.view.frame.height, self.view.frame.width, webView.frame.height)
                                    }, completion: {
                                        _ in
                                        webView.removeFromSuperview()
                                })
                            });
                        } else {
                            print("Could not parse response data")
                        }
                    }
                } else {
                    print("Response data is nil")
                }
            })
        })
    }
    
    @IBAction func sliderValueChanged(slider: UISlider) {
        if slider == redSlider || slider == greenSlider || slider == blueSlider {
            updateColor()
        } else if slider == speedSlider {
            updateSpeed()
        }
    }

}
