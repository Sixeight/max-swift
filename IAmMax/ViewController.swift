//
//  ViewController.swift
//  IAmMax
//
//  Created by Tomohiro Nishimura on 2015/01/29.
//  Copyright (c) 2015年 Tomohiro Nishimura. All rights reserved.
//

import UIKit
import Social
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "myCell"
    
    let maxURL = "https://gist.githubusercontent.com/hitode909/4cd0be11c89743710599/raw/ce4623c73101942e53f9da11ce601ba57f145136/max.txt"
    var maxs: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        Alamofire.request(.GET, self.maxURL)
            .responseString { _, _, body, _ in
                let maxs = body?.componentsSeparatedByString("\n")
                self.maxs = maxs!
                self.tableView.reloadData()
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func composeTapped(sender: AnyObject) {
        let randomIndex = Int(arc4random_uniform(UInt32(self.maxs.count)))
        let max = self.maxs[randomIndex]
        tweet(iAmMax(max))
    }
    
    func tweet(tweet: String) {
        var vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText(tweet)
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func iAmMax(name: String) -> String {
        return "こんにちは。私は\(name)。"
    }
    
    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.maxs.count
    }
    
    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var max = self.maxs[indexPath.row]
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = iAmMax(max)
        cell.detailTextLabel?.text = max
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let max = self.maxs[indexPath.row]
        tweet(iAmMax(max))
    }
}

