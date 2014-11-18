//
//  FeedParser.swift
//  App Reviews
//
//  Created by Raheel Ahmad on 11/17/14.
//  Copyright (c) 2014 Sakun Labs. All rights reserved.
//

import Foundation

typealias FeedFetchCompletion = (NSData?, NSError?) -> ()

class FeedFetcher {
    let feedURL = NSURL(string: "https://itunes.apple.com/us/rss/customerreviews/id=542557212/sortBy=mostRecent/json")
    lazy var urlSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        return session
    }()
	func fetchFeed(completion: FeedFetchCompletion) {
        let feedRequest = NSURLRequest(URL: feedURL!)
        let feedFetchTask = urlSession.dataTaskWithRequest(feedRequest) { [unowned self] data, response, error in
			var fetchError = error
            if let httpResponse = response as? NSHTTPURLResponse {
                if !self.OKStatusCode(httpResponse) {
					fetchError = NSError()
                }
            }
			self.notify(completion, data: data, error: error)
        }
        
        feedFetchTask.resume()
    }
	
	func notify(completion: FeedFetchCompletion, data: NSData?, error: NSError?) {
		dispatch_async(dispatch_get_main_queue()) {
			completion(data, error)
		}
	}
	
    func OKStatusCode(response: NSHTTPURLResponse) -> Bool {
        switch(response.statusCode) {
        case 0...99:
            return false
        case 100...199:
            return true
        case 200...299:
            return true
        case 300...399:
            return true
        case 400...599:
            return false
        default:
            return false
        }
    }

}
