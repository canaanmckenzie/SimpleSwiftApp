//
//  Album.swift
//  SimpleSwiftApp
//
//  Created by devmachine on 6/25/14.
//  Copyright (c) 2014 MyDev. All rights reserved.
//

import Foundation


class Album{
    var title: String?
    var price: String?
    var thumbnailImageURL: String?
    var itemURL: String?
    var artistURL: String?
    var largeImageURL:String?
    
    init(name: String!, price: String!, thumbnailImageURL: String!,largeImageURL:String!,itemURL: String!, artistURL:String!){
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
    }
}