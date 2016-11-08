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
        let rawData = rawDataFromURL(mURL!)
        //parse json
        currentPix = pictureArrayFromRawData(rawData)!
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
        let rawData = rawDataFromURL(mURL!)
        currentPix = pictureArrayFromRawData(rawData)!
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
        return nil
    }
    
    private func rawDataFromURL(url: NSURL)->AnyObject?{
        return nil
    }
    
    private func pictureArrayFromRawData(data: AnyObject?)->Array<FlickrPix>?{
        return nil
    }
}