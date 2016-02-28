//
//  UserViewController.swift
//  PeekShare
//
//  Created by Akshat Goyal on 2/28/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController {

    var user: PFUser?
    @IBOutlet weak var profilrPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        profilrPic.layer.cornerRadius = 75
        profilrPic.clipsToBounds = true
        
        if let userPicture = user!["profilePic"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilrPic.image = UIImage(data: imageData!)
                }
            }
        }
        
        self.nameLabel.text = user?.username
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logoutSegue", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
