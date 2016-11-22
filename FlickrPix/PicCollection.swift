//
//  PicCollection.swift
//  FlickrPix
//
//  Created by Kory E King on 11/3/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import Foundation
import UIKit

class PicCollection {
    
    var currentPix = Array<FlickrPix>()
    
    init(){
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
                       selector: Selector(freeupMemory()),
                       name: UIApplicationDidReceiveMemoryWarningNotification,
                       object: nil)
    }
    
    func getRecentPix(completionHandler: ((Array<FlickrPix>) -> Void)? = nil){
        //create url
        let mURL = createURL(.Recent)
        //temp until functions are filled
        if let realURL = mURL{
            picturesFromURL(realURL, completionHandler: completionHandler)
        }
    }
    
    func searchPix(searchString: String, completionHandler: ((Array<FlickrPix>) -> Void)? = nil){
        //create url for request
        let mURL = createURL(.Search(searchString))
        //temp until functions are filled
        if let realURL = mURL{
            picturesFromURL(realURL, completionHandler: completionHandler)
        }
        
    }
    
    // clears the photos
    func deleteAllPix(){
        currentPix.removeAll()
    }
    
    //delete actual images
    func freeupMemory(){
        for i in currentPix{
            i.bigPix = nil
            i.thumbn = nil
        }
    }
    
    //clean up notification
    deinit{
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }
    
    //MARK: -- Private internal function
    private enum URLAction{
        case Recent
        case Search(String)
    }
    
    private func createURL(action: URLAction)->NSURL?{
        let urlComponents = NSURLComponents(string: "https://api.flickr.com/services/rest")
        var params = Dictionary<String, String>()
        params["api_key"] = Constants.APIKey.flickrAPIKey
        params["format"] = "json"
        params["nojsoncallback"] = "1"
        //specify what we want
        params["extras"] = "date_taken,url_h,url_t,descriptions"
        //filter safe PG-13 pictures, comment to turn filter off ;-)
        //params["safe_search"] = "1"
        //check request type
        switch action {
        case .Recent:
            params["method"] = "flickr.photos.getrecent"
        case .Search(let searchTerm):
            params["method"] = "flickr.photos.search"
            params["text"] = searchTerm
        }
        
        var query = Array<NSURLQueryItem>()
        
        for (key, value) in params{
            query.append(NSURLQueryItem(name: key, value: value))
        }
        urlComponents?.queryItems = query
        print(urlComponents?.string)
        return urlComponents?.URL
    }
    
    
    private func picturesFromURL(url: NSURL, completionHandler: ((Array<FlickrPix>) -> Void)? = nil){
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        ////<#T##(NSData?, NSURLResponse?, NSError?) -> Void#>
        let task = session.dataTaskWithRequest(request, completionHandler:
        {
            (data, response, error) in
            if let actualError = error {
                print("Mayday we got an error \(actualError)")
            }else if let _ = response, actualData = data{
                //temp array for extracted data
                var tempFlPxAr = Array<FlickrPix>()
                var jsonError: NSError?
                let parseData = JSON.init(data: actualData, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                
                let dateFormat = NSDateFormatter()
                
                let photodata = parseData["photos"]["photo"]
                for (key, jsonValue) : (String, JSON) in photodata {
                    let title = jsonValue["title"].string
                    let url_t = jsonValue["url_t"].string
                    let url_h = jsonValue["url_h"].string
                    
                    if( nil != title && nil != url_t && nil != url_h){
                        let desc = jsonValue["description"].string
                        let date_S = jsonValue["dateTaken"].string
                        let owner = jsonValue["owner"].string
                        
                        let realURLT = NSURL(string: url_h!)
                        let realURLH = NSURL(string: url_t!)
                        if nil != realURLT && nil != realURLH {
                            let date: NSDate? = (nil == date_S) ? nil: dateFormat.dateFromString(date_S!)
                            let Flckrpx = FlickrPix.init(title: title!,
                                                     url_h: realURLT!,
                                                    url_t: realURLH!,
                                                    desc: desc,
                                                    date: date,
                                                    owner: owner)
                            
                            tempFlPxAr.append(Flckrpx)
                        }
                    }
//                    for (jsonkey, _) in jsonValue{
//                        print("SubKey: \(jsonkey)")
//                    }
                    
                }
                print("We have \(tempFlPxAr.count) pictures")
                self.currentPix = tempFlPxAr
                
                //this code contains VC code which needs to be run/dispatched to main thread
                if let actualCP = completionHandler{
                    dispatch_async(dispatch_get_main_queue(), {
                      actualCP(self.currentPix)
                    })
                }
            }
        }) //end of task handler
        
        task.resume()
    }
    
    private func pictureArrayFromRawData(data: AnyObject?)->Array<FlickrPix>{
        return Array<FlickrPix>()
    }
}