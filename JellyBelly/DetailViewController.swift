//
//  DetailViewController.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var profileImageView: UIImageView!


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
			backgroundImageView?.image = chef.backgroundImage
			profileImageView?.image = chef.profileImage
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

