//
//  HTTPRequestHandler.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import UIKit

class HTTPRequestHandler: NSObject {
    let baseURL = "http://192.168.0.138:9001"
    
    static let sharedInstance = HTTPRequestHandler()
    
    var command: String = "None"
    var color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    var speed: Float = 1.0
    var bpm: Int = 1
    var dynaColor: Bool = false
    
    func getListOfCommands(completion: (commands: [String]) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+"/request/validcommands")!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let _: Void = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if error != nil {
                print(error)
            }
            var commands = [String]()
            if data != nil {
                if let HTMLString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    let document = HTMLDocument(string: HTMLString as String)
                    if let list = document.firstNodeMatchingSelector("ul") {
                        for child in list.mutableChildren {
                            if let command = child.textContent {
                                commands.append(command)
                            } else {
                                print("No text in list element")
                            }
                        }
                    } else {
                        print("No List")
                    }
                } else {
                    print("Encoding Error")
                }
            } else {
                print("Data is nil")
            }
            completion(commands: commands)
        }).resume()
    }
    
    
    func sendCommand(command: String, completion: (responseData: NSData?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+"/command/"+command)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let _: Void = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            completion(responseData: data)
        }).resume()
    }
    
    func sendSpeed(speed: Double, completion: (responseData: NSData?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+"/speed/"+String(speed))!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let _: Void = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            completion(responseData: data)
        }).resume()
    }
    
    func sendColor(color: UIColor, completion: (responseData: NSData?) -> Void) {
        let hexString = color.hexStringValue
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+"/color/"+hexString)!)
        
        let session = NSURLSession.sharedSession()
        let _: Void = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            completion(responseData: data)
        }).resume()
    }
	
	func sendBPM(bpm: Int, completion: (responseData: NSData?) -> Void) {
		let bpmString = String(bpm)
		
		let request = NSMutableURLRequest(URL: NSURL(string: baseURL+"/bpm/"+bpmString)!)
		
		let session = NSURLSession.sharedSession()
		let _: Void = session.dataTaskWithRequest(request, completionHandler: {
			data, response, error in
			completion(responseData: data)
		}).resume()
	}
    
    func parseJSONReply(data: NSData) throws -> Dictionary<String,AnyObject> {
        let value: Dictionary<String,AnyObject>?
        do {
            value = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String,AnyObject>
            return value!
        } catch let error as NSError {
            throw error
        }
    }
    
    func refreshState(completion: (error: NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "/request/stateJSON")!)
        
        let session = NSURLSession.sharedSession()
        let _: Void = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            if error != nil || data == nil {
                completion(error: error)
            } else {
                do {
                    let reply = try self.parseJSONReply(data!)
                    let red = reply["colorR"] as! CGFloat
                    let green = reply["colorG"] as! CGFloat
                    let blue = reply["colorB"] as! CGFloat
                    self.color = UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
                    self.speed = reply["speed"] as! Float
                    self.bpm = reply["bpm"] as! Int
                    self.dynaColor = reply["dynaColor"] as! Bool
                    self.command = reply["command"] as! String
                    
                    completion(error: nil)
                } catch let error as NSError {
                    completion(error: error)
                }
            }
        }).resume()
        
    }
}
