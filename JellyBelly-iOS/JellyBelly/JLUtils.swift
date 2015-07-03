//
//  JLUtils.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit

extension UIImage {
	func circularCopy() -> UIImage {
		let borderColor = UIColor.lightGrayColor().CGColor
		let insetRadius: CGFloat = 4.0
		let radius = min(size.width, size.height) / 2.0
		// draw the image
		let contextSize = CGSizeMake(self.size.width + (2 * insetRadius), self.size.height + (2 * insetRadius))
		UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.mainScreen().scale)
		CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), borderColor)
		
		let cropRect = CGRectMake((size.width / 2.0) - radius, (size.height / 2.0) - radius, 2 * radius, 2 * radius)
		let borderRect = CGRectInset(cropRect, -2 * insetRadius, -2 * insetRadius)
		
		// draw background color
		UIBezierPath(roundedRect: borderRect, cornerRadius: radius + insetRadius).addClip()
		CGContextFillRect(UIGraphicsGetCurrentContext(), borderRect)
		// draw the image
		UIBezierPath(roundedRect: cropRect, cornerRadius: radius).addClip()
		self.drawInRect(cropRect)
		
		let circleImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return circleImage
	}
}
