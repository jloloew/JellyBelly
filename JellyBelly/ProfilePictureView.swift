//
//  ProfilePictureView.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit

@IBDesignable
class ProfilePictureView: UIView {
	
//	@IBInspectable var inset
	@IBInspectable var image: UIImage!
	private var imageView: UIImageView!
	
	private func setUp() {
		layer.masksToBounds = true
//		view.edge
	}
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
