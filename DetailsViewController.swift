//
//  DetailsViewController.swift
//  SimpleSwiftApp
//
//  Created by devmachine on 6/25/14.
//  Copyright (c) 2014 MyDev. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var albumCover: UIImageView
    
    @IBOutlet var albumTitle: UILabel
    
    var album: Album?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTitle.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album?.largeImageURL)))
    }
}
