//
//  ViewController.swift
//  FlickrPix
//
//  Created by Kory E King on 11/3/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let pics = PicCollection()
        print("getting recent")
        pics.getRecentPix() {
            (arrayOfPics) in
            print("In the VC, we got back \(arrayOfPics.count)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

