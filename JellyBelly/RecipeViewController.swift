//
//  RecipeViewController.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/28/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit
import Alamofire
import Braintree
import SwiftyJSON

class RecipeViewController: UIViewController, BTDropInViewControllerDelegate {
	
	var braintree: Braintree!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Alamofire.request(.GET, DataSource.defaultDataSource().host + "/client_token")
			.responseJSON { (_, _, json, error) -> Void in
				if let error = error {
					println(error)
				} else {
					let json = JSON(json!)
					let token = json["client_token"].string!
					println("Got client token " + token)
					self.braintree = Braintree(clientToken: token)
				}
		}

	}
	
	@IBAction func payButtonTapped(sender: AnyObject) {
		let dropInVC = braintree.dropInViewControllerWithDelegate(self)
		dropInVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "userDidCancelPayment")
		let navCon = UINavigationController(rootViewController: dropInVC)
		self.presentViewController(navCon, animated: true, completion: nil)
	}
	
	func userDidCancelPayment() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func postNonceToServer(paymentMethodNonce: String) {
		let paymentURL = NSURL(string: DataSource.defaultDataSource().host + "/payment_methods")!
		var request = NSMutableURLRequest(URL: paymentURL)
		request.HTTPMethod = "POST"
		request.setValue("text/plain", forHTTPHeaderField: "Accept")
		let str = "payment_method_nonce=\(paymentMethodNonce)&amount=123"
		request.HTTPBody = str.dataUsingEncoding(NSUTF8StringEncoding)
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
			if let error = error {
				println(error)
			} else {
				println("Successfully sent payment.")
				let dataStr = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
				println("Received data \(dataStr)")
			}
		}
	}
	
	// MARK: - BTDropInViewControllerDelegate
	
	func dropInViewController(_: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!) {
		postNonceToServer(paymentMethod.nonce)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func dropInViewControllerDidCancel(viewController: BTDropInViewController!) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
}
