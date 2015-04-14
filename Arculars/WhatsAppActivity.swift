//
//  InstagramActivity.swift
//  Arculars
//
//  Created by Roman Blum on 14/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit

class WhatsAppActivity : UIActivity, UIDocumentInteractionControllerDelegate {
    
    private var docController : UIDocumentInteractionController!
    private var parent : UIViewController!
    private var image : UIImage?
    
    init(parent: UIViewController) {
        self.parent = parent
    }
    
    override func activityType()-> String {
        return NSStringFromClass(self.classForCoder)
    }
    
    override func activityImage()-> UIImage
    {
        return UIImage(named: "icon-whatsapp")!
    }
    
    override func activityTitle() -> String
    {
        return "WhatsApp";
    }
    
    override class func activityCategory() -> UIActivityCategory{
        return UIActivityCategory.Share
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        var whatsappURL : NSURL? = NSURL(string: "whatsapp://app")
        if (!UIApplication.sharedApplication().canOpenURL(whatsappURL!)) {
            return false
        }
        
        for activityItem in activityItems
        {
            if (activityItem.isKindOfClass(UIImage)) { return true }
        }
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for activityItem in activityItems {
            if (activityItem.isKindOfClass(UIImage))
            {
                self.image = activityItem as? UIImage
            }
        }
    }
    
    override func performActivity() {
        var saveImagePath = NSTemporaryDirectory().stringByAppendingPathComponent("image.wai")
        var imageData = UIImagePNGRepresentation(self.image)
        imageData.writeToFile(saveImagePath, atomically: true)
        
        var imageURL = NSURL(fileURLWithPath: saveImagePath)
        
        docController = UIDocumentInteractionController(URL: imageURL!)
        docController.delegate = self
        docController.UTI = "net.whatsapp.image"
        
        docController.presentOpenInMenuFromRect(CGRectZero, inView: parent.view, animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return parent
    }
}