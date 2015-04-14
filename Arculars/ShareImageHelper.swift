//
//  ShareImageHelper.swift
//  Arculars
//
//  Created by Roman Blum on 14/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import UIKit

class ShareImageHelper {
    
    class func createImage(score: Int, image: String) -> UIImage {
        // load image to get dimensions
        var loadedImage = UIImage(named: image)
        
        // begin context
        UIGraphicsBeginImageContext(loadedImage!.size)
        var ctx = UIGraphicsGetCurrentContext()
        
        // add image to background of context
        loadedImage!.drawInRect(CGRectMake(0, 0, loadedImage!.size.width, loadedImage!.size.height))
        
        // set text matrix so the text is not upside down
        CGContextSetTextMatrix(ctx, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0))
        
        // add the text to the context
        drawScore(ctx, text: "\(score)", fontSize: CGFloat(loadedImage!.size.height / 4), x: loadedImage!.size.width / 2, y: loadedImage!.size.height / 2)
        
        // get the new image from the context
        let updatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return updatedImage
    }
    
    private class func drawScore(context: CGContextRef, text: NSString, fontSize: CGFloat, x: CGFloat, y: CGFloat) -> CGSize {
        let font = CTFontCreateWithName(Fonts.FontNameBold, fontSize, nil) as UIFont
        let fontColor = Colors.PowerupColor.CGColor
        
        var textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName : fontColor,
            NSFontAttributeName : font
        ]
        
        let attributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)
        CFAttributedStringReplaceString (attributedString, CFRangeMake(0, 0), text)
        CFAttributedStringSetAttribute(attributedString, CFRangeMake(0, CFAttributedStringGetLength(attributedString)), NSFontAttributeName, font)
        CFAttributedStringSetAttribute(attributedString, CFRangeMake(0, CFAttributedStringGetLength(attributedString)), NSForegroundColorAttributeName, fontColor)
        
        let textSize = text.sizeWithAttributes(textAttributes)
        let textPath    = CGPathCreateWithRect(CGRect(x: x - (textSize.width / 2)
            , y: y, width: ceil(textSize.width), height: ceil(textSize.height)), nil)
        
        var alignment = CTTextAlignment.TextAlignmentCenter
        let alignmentSetting = [CTParagraphStyleSetting(spec: .Alignment, valueSize: Int(sizeofValue(alignment)), value: &alignment)]
        //let paragraphStyle = CTParagraphStyleCreate(alignmentSetting, 1)
        let paragraphStyle = CTParagraphStyleCreate(alignmentSetting, Int(alignmentSetting.count))
        CFAttributedStringSetAttribute(attributedString, CFRangeMake(0, CFAttributedStringGetLength(attributedString)), kCTParagraphStyleAttributeName, paragraphStyle)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: CFAttributedStringGetLength(attributedString)), textPath, nil)
        
        CTFrameDraw(frame, context)
        
        return textSize
    }
}