//
//  FlickrPix.swift
//  FlickrPix
//
//  Created by Kory E King on 11/3/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import Foundation
import UIKit

class FlickrPix{
    
    var url_t: NSURL
    var url_h: NSURL
    var description: String?
    var dateTaken: NSDate?
    var title: String
    var owner: String?
    lazy var bigPicture: UIImage? = {
        print("big pic lazy")
        return nil
    }()
    lazy var thumbn: UIImage? = {
        print("thumb pic lazy")
        return nil
    }()
    
    init(title: String, url_h: NSURL, url_t: NSURL, desc: String?, date: NSDate?, owner: String?){
        self.title = title
        self.url_t = url_t
        self.url_h = url_h
        self.description = desc
        self.dateTaken = date
        self.owner = owner
    }
    
    
    
}