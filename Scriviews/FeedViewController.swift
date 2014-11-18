//
//  FeedViewController.swift
//  Scriviews
//
//  Created by Raheel Ahmad on 10/11/14.
//  Copyright (c) 2014 Sakun Labs. All rights reserved.
//

import UIKit

struct Entry {
    let position: Int
    let authorName: String
    let rating: String
    var date: NSDate?
    var title: String?
    var content: String?
    var appVersion: String?
}

class FeedViewController: UITableViewController {
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var sortingControl: UISegmentedControl!
	let feedFetcher = FeedFetcher()
	let parser = FeedParser()
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parser.entriesCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let entry = parser.entryAtIndex(indexPath.row) {
			let cellId = cellIdentifierForEntry(entry)
			let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
			configureCell(cell, entry: entry)
			return cell
		} else {
			return UITableViewCell()
		}
    }
    
    func configureCell(var cell: UITableViewCell, entry: Entry) {
        if let cell = cell as? RatingCell {
            cell.ratingLabel.text = stars(entry.rating)
            cell.nameLabel.text = entry.authorName
        }
        else if let cell = cell as? RatingTitleCell {
            cell.ratingLabel.text = stars(entry.rating)
            cell.nameLabel.text = entry.authorName
            cell.titleLabel_.text = entry.title!
        }
    }
    
    func stars(count: String) -> String {
        var stars = ""
        if let count = count.toInt() {
            for _ in 1...count { stars = "\(stars)★" }
        }
        return stars
    }
    
    @IBAction func switchSorting() {
		if let sorting = Sorting(rawValue: sortingControl.selectedSegmentIndex) {
			parser.switchSorting(sorting)
			tableView.reloadData()
		}
    }
    
    @IBAction func reload(sender: AnyObject) {
		if feedFetcher.feedURL == nil {
			askForAppID()
		} else {
			fetchFeed()
		}
    }
	
	func fetchFeed() {
        reloadButton.enabled = false
		feedFetcher.fetchFeed() { [unowned self] data, error in
			if error != nil {
				self.showError()
				self.reloadButton.enabled = true
			} else if let data = data {
				self.reloadButton.enabled = true
				self.parser.parseFeedData(data)
				self.switchSorting()
				self.tableView.reloadData()
			}
		}
	}

	func askForAppID() {
		let askForAppIDView = UIAlertView(title: "Enter App ID",
			message: "Enter your app ID",
			delegate: self,
			cancelButtonTitle: "Cancel")
		askForAppIDView.alertViewStyle = UIAlertViewStyle.PlainTextInput
		askForAppIDView.addButtonWithTitle("OK")
		askForAppIDView.show()
	}

    func showError() {
		UIAlertView(title: "Error fetching the reviews",
			message: "There was an error fetching and parsing the feed.",
			delegate: nil,
			cancelButtonTitle: "OK").show()
    }
    
    let RatingCellId = "Rating"
    let RatingTitleCellId = "RatingTitle"
    
    func cellIdentifierForEntry(entry: Entry) -> String {
        if allPresent(entry.title) { return RatingTitleCellId }
        else { return RatingCellId }
    }
    
    func allPresent<T>(items: T?...) -> Bool {
        for item in items {
            if item == nil { return false }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		reload(self)
	}
}

extension FeedViewController: UIAlertViewDelegate {
	func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
		if buttonIndex == 1 {
			if let appID = alertView.textFieldAtIndex(0)?.text {
				feedFetcher.feedURL = NSURL(string: "https://itunes.apple.com/us/rss/customerreviews/id=\(appID)/sortBy=mostRecent/json")
				reload(self)
			}
		}
	}
}

