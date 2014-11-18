//
//  FeedParser.swift
//  App Reviews
//
//  Created by Raheel Ahmad on 11/17/14.
//  Copyright (c) 2014 Sakun Labs. All rights reserved.
//

import Foundation

enum Sorting: Int {
	case ByPosition = 0
	case ByRating
}
    
class FeedParser {
    typealias JSON = [String:AnyObject]
	private lazy var entries = [Entry]()
	
	var entriesCount: Int {
		return entries.count
	}
	
	func entryAtIndex(index: Int) -> Entry? { return entries[index] }
	
    func parseFeedData(data: NSData) {
        var error: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? JSON {
            if let feed = json["feed"] as AnyObject? as? JSON {
                if let entriesJSON = feed["entry"] as AnyObject? as? Array<JSON> {
                    entries.removeAll(keepCapacity: true)
                    for (i, entryJSON) in enumerate(entriesJSON) {
                        if let entry = parseEntry(entryJSON, position: i) {
                            entries.append(entry)
                        }
                    }
                }
                
                if let linksJSON = feed["link"] as AnyObject? as? Array<JSON> {
                    for (i, linkJSON) in enumerate(linksJSON) {
//                        if let linkJSON = linkJSON as
////                        if let attributesJSON = linkJSON["attributes"] as? AnyObject? as? Dictionary {
//                        
//                        }
                    }
                }
            }
        }
    }
	
	func reset() {
		entries.removeAll(keepCapacity: false)
	}
	
	func switchSorting(sorting: Sorting) {
		switch sorting {
		case .ByPosition:
			entries = sorted(entries, { one, two in one.position < two.position })
		case .ByRating:
			entries = sorted(entries, { one, two in one.rating.toInt() > two.rating.toInt() })
		}
	}
    
    private func parseEntry(entryJSON: JSON, position: Int) -> Entry? {
        var name: String?
        var appVersion: String?
        var rating: String?
        var title: String?
        var content: String?
        var date: NSDate?
        if let author = entryJSON["author"] as AnyObject? as? JSON {
            if let nameDict = author["name"] as AnyObject? as JSON? {
                name = nameDict["label"] as AnyObject? as String?
            }
        }
        if let dateDict = entryJSON["im:releaseDate"] as AnyObject? as? JSON {
            if let dateString = dateDict["label"] as AnyObject? as String? {
                let df = NSDateFormatter()
                df.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZZZZZ"
                date = df.dateFromString(dateString)
            }
        }
        if let appVersionDict = entryJSON["im:version"] as AnyObject? as? JSON {
            appVersion = appVersionDict["label"] as AnyObject? as String?
        }
        if let ratingDict = entryJSON["im:rating"] as AnyObject? as? JSON {
            rating = ratingDict["label"] as AnyObject? as String?
        }
        if let titleDict = entryJSON["title"] as AnyObject? as? JSON {
            title = titleDict["label"] as AnyObject? as String?
        }
        if let contentDict = entryJSON["content"] as AnyObject? as? JSON {
            title = contentDict["label"] as AnyObject? as String?
        }
        
        if name != nil && rating != nil {
            return Entry(position: position, authorName: name!, rating: rating!, date: date, title: title, content: content, appVersion: appVersion)
        } else {
            return nil
        }
    }
}
