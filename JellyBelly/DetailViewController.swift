//
//  DetailViewController.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
	
	@IBOutlet weak var recipe1: UIButton!
	@IBOutlet weak var recipe2: UIButton!
	@IBOutlet weak var recipe3: UIButton!
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var mapView: MKMapView!
	
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var location: UILabel!
	@IBOutlet weak var starRating: UILabel!
	@IBOutlet weak var percentageRatingLabel: UILabel!
	var percentageRating = 0.75 {
		didSet {
			percentageRatingLabel?.text = "\(100 * percentageRating)% yum"
			// set star rating
			var str = ""
			var sum = percentageRating
			var count = 0
			while sum >= 0.1 && count < 5 {
				str += "⭐️"
				sum -= 0.2
				count++
			}
			while count < 5 {
				str += "✩"
				count++
			}
			starRating?.text = str
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.navigationItem.title = name?.text
		
		scrollView.contentInset = UIEdgeInsetsZero
		scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
		
		let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.84, longitude: -87.68), span: MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35))
		mapView.setRegion(region, animated: true)
	}
	
	var chef: Chef? {
		didSet {
			// Update the view.
			self.configureView()
			// start listening for changes
			let nc = NSNotificationCenter.defaultCenter()
			if let _ = chefNCObserver {
				nc.removeObserver(self.chefNCObserver, name: ChefDidUpdateNotificationKey, object: oldValue)
				self.chefNCObserver = nil
			}
			if let _ = chef {
				nc.addObserverForName(ChefDidUpdateNotificationKey, object: self.chef, queue: nil) { (_) -> Void in
					self.configureView()
				}
			}
		}
	}
	private var chefNCObserver: NSObjectProtocol!
	
	deinit {
		let nc = NSNotificationCenter.defaultCenter()
		nc.removeObserver(chefNCObserver, name: ChefDidUpdateNotificationKey, object: chef)
		chefNCObserver = nil
	}
	
	/// Update the UI.
	func configureView() {
		if let chef = self.chef {
			name?.text = chef.name
			location?.text = chef.locationDescription
			profileImageView?.image = chef.profileImage
			descriptionTextView?.editable = true
			descriptionTextView?.text = chef.bio
			descriptionTextView?.editable = false
			percentageRating = chef.rating
			
			self.navigationItem.title = self.name?.text
			
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
	}
	
}

