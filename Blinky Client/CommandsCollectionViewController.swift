//
//  CommandsCollectionViewController.swift
//  Blinky Client
//
//  Created by Evan Bernstein on 10/5/15.
//  Copyright © 2015 Evan Bernstein. All rights reserved.
//

import UIKit
import WebKit

private let reuseIdentifier = "Cell"

class CommandsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var commandLabel: UILabel!
}

class CommandsCollectionViewController: UICollectionViewController {
    
    var commands = [String]()
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        HTTPRequestHandler.sharedInstance.getListOfCommands({
            _commands in
            dispatch_async(dispatch_get_main_queue(), {
                if _commands.count > 0 {
                    self.commands = _commands
                    self.collectionView?.reloadData()
                }
            })
        })
        
        HTTPRequestHandler.sharedInstance.refreshState({
            error in
            if (error != nil) {
                print("Error refreshing state: %@",error)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commands.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CommandsCollectionViewCell
    
        // Configure the cell
        let command = commands[indexPath.item]
        
        cell.commandLabel.text = command
        cell.commandLabel.adjustsFontSizeToFitWidth = true
        
        if (command == HTTPRequestHandler.sharedInstance.command) {
            cell.backgroundColor = UIColor.lightGrayColor()
        } else {
            cell.backgroundColor = UIColor.clearColor()
        }
        
        if (command == "DCStart") {
            cell.backgroundColor = HTTPRequestHandler.sharedInstance.dynaColor ? UIColor.lightGrayColor() : UIColor.clearColor()
        }
        if (command == "DCStop") {
            cell.backgroundColor = HTTPRequestHandler.sharedInstance.dynaColor ? UIColor.clearColor() : UIColor.lightGrayColor()
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let command = commands[indexPath.item]
        if (command == "DCStart") {
            HTTPRequestHandler.sharedInstance.dynaColor = true
        } else if (command == "DCStop") {
            HTTPRequestHandler.sharedInstance.dynaColor = false
        } else {
            HTTPRequestHandler.sharedInstance.command = command
        }
        self.collectionView?.reloadData()
        
        HTTPRequestHandler.sharedInstance.sendCommand(command, completion: {
            data in
            if data != nil {
                /*
                self.showWebViewWithData(data!)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.dismissWebView()
                })
                */
            } else {
                print("Response data is nil")
            }
        })
    }
    
    
    func showWebViewWithData(data: NSData) {
        if let HTMLString = NSString(data: data, encoding: NSUTF8StringEncoding) {
            dispatch_async(dispatch_get_main_queue(), {
                self.webView = WKWebView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 100))
                self.webView!.loadHTMLString(HTMLString as String, baseURL: nil)
                self.view.addSubview(self.webView!)
                self.webView?.scrollView.userInteractionEnabled = false
                let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(CommandsCollectionViewController.dismissWebView))
                swipeDownGesture.direction = .Down
                self.webView?.addGestureRecognizer(swipeDownGesture)
                UIView.animateWithDuration(0.5, animations: {
                    self.webView!.frame = CGRectMake(self.webView!.frame.origin.x, self.view.frame.height-self.webView!.frame.height, self.view.frame.width, self.webView!.frame.height)
                })
            })
        } else {
            print("Could not parse response data")
        }
    }
    
    func dismissWebView() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.5, animations: {
                self.webView?.frame = CGRectMake(self.webView!.frame.origin.x, self.view.frame.height, self.view.frame.width, self.webView!.frame.height)
                }, completion: {
                    _ in
                    self.webView?.removeFromSuperview()
            })
        })
    }

}
