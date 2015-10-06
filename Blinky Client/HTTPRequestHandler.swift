//
//  HTTPRequestHandler.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import UIKit

class HTTPRequestHandler: NSObject {
    let baseURL = "192.168.0.137:9001"
    
    static let sharedInstance = HTTPRequestHandler()
    
    func getListOfCommands(completion: (commands: [String]) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+"/request/validcommands")!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let _: Void = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            print("response!")
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
}
