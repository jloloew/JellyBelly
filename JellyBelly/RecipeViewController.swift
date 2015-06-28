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
//		self.braintree = Braintree(clientToken: "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI2YmUzZWU0NTdhN2M0YzM3YjJkOTAzMGNlNTkzYzk4Yjg0ZmExZmJiZDZlMmI2OWFjM2Y1NzU1MWQ1MTlhM2Y3fGNyZWF0ZWRfYXQ9MjAxNS0wNi0yOFQwNjo1MjowMS4xMjE3OTA0MTQrMDAwMFx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6dHJ1ZSwiY29pbmJhc2UiOnsiY2xpZW50SWQiOiIxMWQyNzIyOWJhNThiNTZkN2UzYzAxYTA1MjdmNGQ1YjQ0NmQ0ZjY4NDgxN2NiNjIzZDI1NWI1NzNhZGRjNTliIiwibWVyY2hhbnRBY2NvdW50IjoiY29pbmJhc2UtZGV2ZWxvcG1lbnQtbWVyY2hhbnRAZ2V0YnJhaW50cmVlLmNvbSIsInNjb3BlcyI6ImF1dGhvcml6YXRpb25zOmJyYWludHJlZSB1c2VyIiwicmVkaXJlY3RVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbS9jb2luYmFzZS9vYXV0aC9yZWRpcmVjdC1sYW5kaW5nLmh0bWwiLCJlbnZpcm9ubWVudCI6Im1vY2sifSwibWVyY2hhbnRJZCI6ImRjcHNweTJicndkanIzcW4iLCJ2ZW5tbyI6Im9mZmxpbmUiLCJhcHBsZVBheSI6eyJzdGF0dXMiOiJtb2NrIiwiY291bnRyeUNvZGUiOiJVUyIsImN1cnJlbmN5Q29kZSI6IlVTRCIsIm1lcmNoYW50SWRlbnRpZmllciI6Im1lcmNoYW50LmNvbS5icmFpbnRyZWVwYXltZW50cy5zYW5kYm94LkJyYWludHJlZS1EZW1vIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4Il19fQ==")
		
		
		Alamofire.request(.GET, DataSource.defaultDataSource().host + "/client_token")
			.responseJSON { (_, _, json, error) -> Void in
				if let error = error {
					println(error)
				} else {
					let json = JSON(json!)
					let token = json["client_token"].string!
//					let token = NSString(data: data! as! NSData, encoding: NSUTF8StringEncoding)! as String
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
		
//		Alamofire.request(.POST, DataSource.defaultDataSource().host + "/payment-methods", parameters: ["payment_method_nonce": paymentMethodNonce])
//		.response { (_, _, data, error) -> Void in
//			if let error = error {
//				println(error)
//			} else {
//				println("Successfully sent payment.")
//			}
//		}
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
