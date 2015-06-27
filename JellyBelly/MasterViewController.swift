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
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
		
//		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//		self.navigationItem.rightBarButtonItem = addButton
		
		dataSource.refresh()
	}
	
	// MARK: - Segues
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
			if let indexPath = self.tableView.indexPathForSelectedRow() {
				let object = allChefs[indexPath.row]
				(segue.destinationViewController as! DetailViewController).detailItem = object
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
		
		let chef = allChefs[indexPath.row]
		cell.textLabel!.text = chef.name
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

