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
	
	var allChefs = [Chef]()
	private(set) var lastUpdated: NSDate!
	
	let serverAddress = "45.55.192.30"
	let serverPort = 3000
	
	/// Refresh the data from the server.
	func refresh(completion: ((error: NSError?) -> Void)? = nil) {
		let url = "\(serverAddress):\(serverPort)/api"
		Alamofire.request(.GET, url, parameters: ["chefs": ["*"]])
			.responseJSON { (req, res, json, error) -> Void in
				if let error = error {
					println(error)
				} else {
					let json = JSON(json!)
					for chef in json["chefs"] {
						// deserialize this chef
						debugPrintln(chef)
					}
				}
				completion?(error: error)
		}
	}
	
}
