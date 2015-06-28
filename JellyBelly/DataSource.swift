//
//  DataSource.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// Handles networking.
class DataSource {
	
	private struct Static {
		static let defaultDataSource = DataSource()
	}
	
	class func defaultDataSource() -> DataSource {
		return Static.defaultDataSource
	}
	
	var allChefs = [Chef]()
	private(set) var lastUpdated: NSDate!
	
	let serverAddress = "45.55.192.30"
	let serverPort = 3000
	var host: String { return "http://\(serverAddress):\(serverPort)" }
	
	/// Refresh the data from the server.
	func refresh(completion: ((error: NSError?) -> Void)? = nil) {
		let url = host + "/api"
		println("sending refresh")
		Alamofire.request(.GET, url, parameters: ["chefs": "*"])
			.responseJSON { (_, _, json, error) -> Void in
				println("finished refresh")
				if let error = error {
					println(error)
				} else {
					let json = JSON(json!)
					self.allChefs = [Chef]()
					for chef in json["chefs"] {
						// deserialize this chef
						debugPrintln(chef)
						let chefDict = JSONToDictionary(chef.1) as NSDictionary?
						self.allChefs.append(Chef(dict: chefDict! as! [String : AnyObject]))
					}
					self.lastUpdated = NSDate()
				}
				completion?(error: error)
		}
	}
	
	/// Fetch an image from a path on the server.
	func fetchImage(#path: String, _ completion: (image: UIImage!, error: NSError!) -> Void) {
		let url = host + path
		println("requesting image " + url)
		Alamofire.request(.GET, url)
			.response { (_, _, data, error) -> Void in
				let image: UIImage!
				if let error = error {
					println(error)
					image = nil
				} else {
					image = UIImage(data: data! as! NSData)
				}
				completion(image: image, error: error)
		}
	}
	
}

/// Recursively unwrap JSON into a Dictionary
func JSONToDictionary(json: JSON) -> [String : AnyObject]? {
	var dict = json.dictionaryObject
	if dict != nil {
		for (k, v) in dict! {
			if let vJson = v as? JSON {
				dict![k] = JSONToDictionary(vJson)
			}
		}
	}
	return dict
}
