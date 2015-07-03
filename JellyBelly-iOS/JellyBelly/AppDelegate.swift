//
//  AppDelegate.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit
import Braintree

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// set app-wide color scheme
//		let primary = UIColor(red: 0xFD / 255.0, green: 0x50 / 255.0, blue: 0x45 / 255.0, alpha: 1.0) // strawberry
		let primary = UIColor(red: 0xA6 / 255.0, green: 0xC1 / 255.0, blue: 0x57 / 255.0, alpha: 1.0) // kiwi
		let secondary = UIColor.darkTextColor()
//		application.statusBarStyle = .LightContent
		let appearance = UINavigationBar.appearance()
		appearance.tintColor = secondary
		appearance.barTintColor = primary
//		appearance.titleTextAttributes = [NSForegroundColorAttributeName : secondary]
		
		Braintree.setReturnURLScheme("com.justinloew.JellyBelly.payments")
		
		return true
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
		return Braintree.handleOpenURL(url, sourceApplication: sourceApplication)
	}
	
}

