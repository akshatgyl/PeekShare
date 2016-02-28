//
//  SignUpViewController.swift
//  PeekShare
//
//  Created by Akshat Goyal on 2/27/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var addimageBtn: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    var selectedImage: UIImage?
    var resizedImage: UIImage?
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
        
        self.view.addSubview(userName)
        self.view.addSubview(password)
        self.view.addSubview(profilePic)
        self.view.addSubview(registerBtn)
        self.view.addSubview(addimageBtn)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        if resizedImage == nil {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Select An Image"
            alert.addButtonWithTitle("OK")
            alert.show()
        } else if userName.text == "" || password.text == "" {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Fill All the Fields"
            alert.addButtonWithTitle("OK")
            alert.show()
        } else {
            let newUser = PFUser()
            newUser.username = userName.text
            newUser.password = password.text
            
            let imageData = UIImageJPEGRepresentation(resizedImage!, 1.0)
            let imageFile = PFFile(data: imageData!)
            newUser.setObject(imageFile!, forKey: "profilePic")
            
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success{
                    print("created user")
                    self.performSegueWithIdentifier("signedUpSegue", sender: nil)
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }

    @IBAction func onAddImage(sender: AnyObject) {
        let myActionSheet =  UIAlertController(title: "Post a new Peek", message: "Select Source", preferredStyle: UIAlertControllerStyle.ActionSheet)
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        myActionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (ACTION :UIAlertAction!)in
            print("Camera")
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }))
        myActionSheet.addAction(UIAlertAction(title: "Photos", style: UIAlertActionStyle.Destructive, handler: { (ACTION :UIAlertAction!)in
            print("photos")
            
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc, animated: true, completion: nil)
            
        }))
        self.presentViewController(myActionSheet, animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            picker.dismissViewControllerAnimated(true, completion: nil)
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let size = CGSize(width: selectedImage!.size.width / 5, height: selectedImage!.size.height / 5)
            resizedImage = self.resize(selectedImage!, newSize: size)
            profilePic.image = selectedImage
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
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
