//
//  LoginViewController.swift
//  PeekShare
//
//  Created by Akshat Goyal on 2/23/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let filePath = NSBundle.mainBundle().pathForResource("nature", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        
        let filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.blackColor()
        filter.alpha = 0.05
        self.view.addSubview(filter)
        self.view.sendSubviewToBack(filter)
        
        self.view.addSubview(usernameLabel)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(signInBtn)
        self.view.addSubview(signUpBtn)
        self.view.addSubview(logo)
        
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
    @IBAction func onSignIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameLabel.text!, password: passwordLabel.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("logged in")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("signupSegue", sender: self)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
    }

}
