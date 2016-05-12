//
//  TimelineViewController.swift
//  PeekShare
//
//  Created by Akshat Goyal on 2/23/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import Parse

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var media: [PFObject]?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
        
    }
    
    func fetch() {
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                self.media = media
                print(media)
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("peekCell", forIndexPath: indexPath) as! PeekCell
        
        let media0 = media![indexPath.section]
        let user = media0["author"] as! PFUser
        let caption = media0["caption"] as! String
        let mainImage = media0["media"] as! PFFile
        mainImage.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                let peek = UIImage(data: imageData!)
                cell.peekView.image = peek
            }
        }
        
        let likesCount = media0["likesCount"] as! Int
        let commentsCount = media0["commentsCount"] as! Int
        cell.likesCountLabel.text = "\(likesCount)"
        cell.commentsCountLabel.text = "\(commentsCount)"
        cell.captionLabel.text = "\(user.username!): \(caption)"
        cell.media0 = media0
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let media = media {
            return media.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.8)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 5, width: 40, height: 40))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 20;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;

        
        let media0 = media![section]
        let user = media0["author"] as! PFUser
        if let userPicture = user["profilePic"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    profileView.image = UIImage(data: imageData!)
                }
            }
        }
        
        headerView.addSubview(profileView)
        
        let label = UILabel(frame: CGRect(x: 60, y: 10, width: 200, height: 30))
        label.textColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
        label.text = user.username
        headerView.addSubview(label)
        
        
        let createdLabel = UILabel(frame: CGRect(x: 280, y: 10, width: 200, height: 30))
        createdLabel.textColor = UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-d HH:mm:ss Z"
        let createdAtString = "\(media0.createdAt!)"
        let createdAt = formatter.dateFromString(createdAtString)
        let time = Int((createdAt?.timeIntervalSinceNow)!)
        if (-time/3600) == 0 {
            createdLabel.text = "\(-time/60)m"
        } else {
            createdLabel.text = "\(-time/3600)h"
        }
        headerView.addSubview(createdLabel)
        return headerView
    }
    
    
    override func viewDidAppear(animated: Bool) {
        fetch()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onUser(sender: AnyObject) {
        self.performSegueWithIdentifier("displayUser", sender: self)
    }

    
    
    @IBAction func onNew(sender: AnyObject) {
        self.performSegueWithIdentifier("displayPost", sender: self)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "displayUser") {
            let vc = segue.destinationViewController as! UserViewController
            vc.user = PFUser.currentUser()
        }
    }
    
}
