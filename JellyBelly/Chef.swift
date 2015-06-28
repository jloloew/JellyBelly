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
	
	var id = -1
	var name: String!
	var profileImage: UIImage!
	var backgroundImage: UIImage!
	var locationCoordinates: [String : Double]!
//	var locationCoordinates: CLLocationCoordinate2D { // use KVC to store this property
//		get {
//			let latLon = self.valueForKey("locationCoordinates") as! [String : Double]
//			let lat = latLon["latitude"]!//.doubleValue
//			let lon = latLon["longitude"]!//.doubleValue
//			return CLLocationCoordinate2D(latitude: lat, longitude: lon)
//		}
//		set {
//			let dict = [
//				"latitude": newValue.latitude,
//				"longitude": newValue.longitude
//			]
//			self.setValue(dict, forKey: "locationCoordinates")
//		}
//	}
	var locationDescription: String!
	var locationType: String!
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
