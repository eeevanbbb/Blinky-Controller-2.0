//
//  SpeedAndColorViewController.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import UIKit
import WebKit

class SpeedAndColorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var colorBox: UIView!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var speedSlider: UISlider!
    @IBOutlet var speedLabel: UILabel!
	
	@IBOutlet var bpmPicker: UIPickerView!
    
    var webViewPresent = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        HTTPRequestHandler.sharedInstance.refreshState({
            error in
            if (error != nil) {
                print("Error refreshing state: %@",error)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshUI()
                })
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func refreshUI() {
        let color = HTTPRequestHandler.sharedInstance.color
        colorBox.backgroundColor = color
        redLabel.text = String(Int(color.red * 255.0))
        greenLabel.text = String(Int(color.green * 255.0))
        blueLabel.text = String(Int(color.blue * 255.0))
        redSlider.setValue(Float(color.red) * 255.0, animated: true)
        greenSlider.setValue(Float(color.green) * 255.0, animated: true)
        blueSlider.setValue(Float(color.blue) * 255.0, animated: true)
        
        speedLabel.text = String(format: "%.1f", arguments: [HTTPRequestHandler.sharedInstance.speed])
        speedSlider.value = HTTPRequestHandler.sharedInstance.speed
        
        bpmPicker.selectRow(HTTPRequestHandler.sharedInstance.bpm-1, inComponent: 0, animated: true)
    }
    
    func updateColor() {
        let color = UIColor(red: CGFloat(redSlider.value)/255.0, green: CGFloat(greenSlider.value)/255.0, blue: CGFloat(blueSlider.value)/255.0, alpha: 1.0)
        colorBox.backgroundColor = color
        redLabel.text = String(Int(redSlider.value))
        greenLabel.text = String(Int(greenSlider.value))
        blueLabel.text = String(Int(blueSlider.value))
        
        HTTPRequestHandler.sharedInstance.sendColor(color, completion: {
            data in
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil {
                    if self.webViewPresent == false {
                        if let HTMLString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                            let webView = WKWebView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 100))
                            webView.loadHTMLString(HTMLString as String, baseURL: nil)
                            self.view.addSubview(webView)
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
//        speedLabel.text = String(speed)
        speedLabel.text = String(format: "%.1f", arguments: [speedSlider.value])
        
        HTTPRequestHandler.sharedInstance.sendSpeed(speed, completion: {
            data in
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil {
                    if self.webViewPresent == false {
                        if let HTMLString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                            let webView = WKWebView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 100))
                            webView.loadHTMLString(HTMLString as String, baseURL: nil)
                            self.view.addSubview(webView)
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
	
	
	
	/* UIPickerView Data Source */
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 200
	}
	
	/* UIPickerView Delegate */
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return String(row+1) + " BPM"
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		HTTPRequestHandler.sharedInstance.sendBPM(row+1, completion: {
			data in
			dispatch_async(dispatch_get_main_queue(), {
				if data != nil {
					if self.webViewPresent == false {
						if let HTMLString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
							let webView = WKWebView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 100))
							webView.loadHTMLString(HTMLString as String, baseURL: nil)
							self.view.addSubview(webView)
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
}
