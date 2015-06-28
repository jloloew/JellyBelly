//
//  MasterViewController.swift
//  JellyBelly
//
//  Created by Justin Loew on 6/27/15.
//  Copyright (c) 2015 Justin Loew. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
	
	var allChefs: [Chef] { return dataSource.allChefs }
	
	var dataSource = DataSource()
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource.refresh { (error) -> Void in
			if error == nil {
				self.tableView.reloadData()
			}
		}
	}
	
	// MARK: - Segues
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showChef" {
			if let indexPath = self.tableView.indexPathForSelectedRow() {
				let chef = allChefs[indexPath.row]
				(segue.destinationViewController as! DetailViewController).chef = chef
			}
		}
	}
	
	// MARK: - Table View
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allChefs.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ChefCell", forIndexPath: indexPath) as! UITableViewCell
		// configure the cell
		let chef = allChefs[indexPath.row]
		cell.textLabel!.text = chef.name
		cell.detailTextLabel!.text = chef.distance
//		cell.imageView!.image = chef.profileImage
//		cell.imageView!.layer.cornerRadius = cell.imageView!.bounds.height / 2
//		cell.imageView!.layer.masksToBounds = true
//		let maskView = UIView(frame: cell.imageView!.frame)
//		maskView.layer.cornerRadius = maskView.frame.height / 2
//		maskView.backgroundColor = UIColor.whiteColor()
//		maskView.clipsToBounds = true
//		cell.imageView!.maskView = maskView
		
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return false
	}
	
//	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//		if editingStyle == .Delete {
//			allChefs.removeAtIndex(indexPath.row)
//			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//		} else if editingStyle == .Insert {
//			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//		}
//	}
	
	
}

