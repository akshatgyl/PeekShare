//
//  PostViewController.swift
//  PeekShare
//
//  Created by Akshat Goyal on 2/25/16.
//  Copyright © 2016 akshat. All rights reserved.
//

import UIKit
import JTProgressHUD
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var thumbImage: UIImageView!
    var selectedImage: UIImage?
    var resizedImage: UIImage?
    @IBOutlet weak var captionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            thumbImage.image = selectedImage
    }
    
    
    @IBAction func onPost(sender: AnyObject) {
        if (resizedImage == nil) {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Select An Image"
            alert.addButtonWithTitle("OK")
            alert.show()
        } else if (captionText.text == "") {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please Enter a Caption"
            alert.addButtonWithTitle("OK")
            alert.show()
        } else {
            JTProgressHUD.show()
            UserMedia.postUserImage(self.resizedImage, withCaption: self.captionText.text) { (success: Bool, error: NSError?) -> Void in
                if success {
                    print("uploaded")
                    JTProgressHUD.hide()
                }
                if error != nil {
                    print("error : \(error)")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
