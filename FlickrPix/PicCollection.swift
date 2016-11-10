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
    
    func getRecentPix()->Array<FlickrPix>?{
        //create url
        let mURL = createURL(.Recent)
        //temp until functions are filled
        if(nil == mURL){
            return nil
        }
        //use url to get JSON
        let rawData = picturesFromURL(mURL!)
        //parse json
       // currentPix = pictureArrayFromRawData(rawData)
        //iterate
        return currentPix
    }
    
    func searchPix(searchString: String)->Array<FlickrPix>?{
        //create url for request
        let mURL = createURL(.Search(searchString))
        //temp until functions are filled
        if(nil == mURL){
            return nil
        }
        let rawData = picturesFromURL(mURL!)
        //currentPix = pictureArrayFromRawData(rawData)
        return nil
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
    
    //Depreciated func
    /*
    private func rawDataFromURL(url: NSURL)->AnyObject?{
        
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        return nil
    }*/
    //Updated ^ func:
    private func picturesFromURL(url: NSURL){
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        ////<#T##(NSData?, NSURLResponse?, NSError?) -> Void#>
        let task = session.dataTaskWithRequest(request, completionHandler:
        {
            (data, response, error) in
            if let actualError = error {
                print("Mayday we got an error \(actualError)")
            }else if let actualResponse = response, actualData = data{
                var jsonError: NSError?
                let parseData = JSON.init(data: actualData, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                print("\(parseData)")
            }
        })
        
        task.resume()
    }
    
    private func pictureArrayFromRawData(data: AnyObject?)->Array<FlickrPix>{
        return Array<FlickrPix>()
    }
}