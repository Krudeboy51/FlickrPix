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
        
        return nil
    }
    
    func searchPix()->Array<FlickrPix>?{
        //create url for request
        //request json data
        //parse json to dictionary
        //iterate through dictionary and create pics and add to Array<FlickrPix>
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
}