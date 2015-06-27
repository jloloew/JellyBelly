//
//  Recipe.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit

class Recipe: NSObject {
	
	var id = -1
	var name = ""
	
	convenience override init() {
		self.init(dict: nil)
	}
	init(dict: [String : AnyObject]!) {
		super.init()
		self.setValuesForKeysWithDictionary(dict) // fuck it, KVC is easier
	}
	
}
