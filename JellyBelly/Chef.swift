//
//  Chef.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit
//import CoreLocation
import Alamofire

let ChefDidUpdateNotificationKey = "ChefDidUpdateNotificationKey"

class Chef: NSObject {
	
	var id: String!
	var name: String!
	var profileImage: UIImage!
	var backgroundImage: UIImage!
	var bio: String!
	var locationCoordinates: [String : Double]!
	var locationDescription: String!
	var locationType: String!
	var rating: Double!
	var recipes = [Recipe]()
	
	/// The distance from the device's current location to the chef.
	var distance: String {
		return "1.2 mi"
	}
	
	convenience override init() {
		self.init(dict: nil)
	}
	init(dict: [String : AnyObject]!) {
		super.init()
		self.setValuesForKeysWithDictionary(dict) // fuck it, KVC is easier
	}
	
	override func setValue(value: AnyObject?, forKey key: String) {
		switch key {
		case "rating":
			rating = (value as! NSNumber).doubleValue
		case "profileImage":
			// crop to a circle
			if let avalue = value as? UIImage {
				profileImage = avalue.circularCopy()
			} else {
				fallthrough
			}
		case "profileImage", "backgroundImage":
			if let value = value as? String {
				// download images
				DataSource.defaultDataSource().fetchImage(path: value) { [weak self] (image, error) -> Void in
					self?.setValue(image, forKey: key)
				}
			} else {
				// push out a notification
				let nc = NSNotificationCenter.defaultCenter()
				nc.postNotificationName(ChefDidUpdateNotificationKey, object: self)
				
				fallthrough
			}
		default:
			super.setValue(value, forKey: key)
		}
	}
	
}
