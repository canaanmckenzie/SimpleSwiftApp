//
//  ViewController.swift
//  SimpleSwiftApp
//
//  Created by devmachine on 6/25/14.
//  Copyright (c) 2014 MyDev. All rights reserved.
//
import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var imageCache = NSMutableDictionary()
    var delegate: APIControllerProtocol?
    
    
    @IBOutlet var appsTableView : UITableView
    
    var albums: Album[] = []
    
    @lazy var api: APIController = APIController(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Deuce")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier: String = "SearchResultCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        //var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        //add a check to make sure trackName data is correct
        //let cellText: String? = rowData["trackName"] as? String
        let album = self.albums[indexPath.row]
        cell.text = album.title
        cell.image = UIImage(named: "Blank52")
        cell.detailTextLabel.text = album.price
        
        //background thread handle image download
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),{
            
           //var urlString: NSString = rowData["artworkUrl60"] as NSString
           let urlString = album.thumbnailImageURL
            
            var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
            
        
            if (!image?) {
                //if image does not exist, download it
                var imgURL: NSURL = NSURL(string: urlString)
                
                //get NSData rep of image
                var request: NSURLRequest = NSURLRequest(URL: imgURL)
                var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in if !error? {
                    //var imgData: NSData = NSData(contentsOfURL: imgURL)
                    image = UIImage(data: data)
                    
                    //store image in cache
                    self.imageCache.setValue(image, forKey: urlString)
                    cell.image = image
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        else {
            cell.image = image
        }
            })

    return cell
}
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//        // Get the row data for the selected row
//       // var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
//        
//        var name: String = rowData["trackName"] as String
//        var formattedPrice: String = rowData["formattedPrice"] as String
//        
//        var alert: UIAlertView = UIAlertView()
//        alert.title = name
//        alert.message = formattedPrice
//        alert.addButtonWithTitle("Ok")
//        alert.show()
    }

    func didReceiveAPIResults(results: NSDictionary) {
        //store the results in our table data array
        if results.count>0 {
            let allResults:NSDictionary[] = results["results"] as NSDictionary[]
            
            //sometimes itunes returns a collection, not a track, so we check both for the 'name' 
            for result: NSDictionary in allResults{
                var name: String? = result["trackName"] as? String
                if !name? {
                    name = result["collectionName"] as? String
                }
                
                //sometimes price comes in as formattedPrice, sometimes as collectionPrice..and sometimes it's a float
                var price: String? = result["formattedPrice"] as? String
                if !price? {
                    var priceFloat = result["collectionPrice"] as? Float
                    var nf: NSNumberFormatter = NSNumberFormatter()
                    nf.maximumFractionDigits = 2;
                    if priceFloat? {
                        price = "$"+nf.stringFromNumber(priceFloat)
                    }
                }
            
        
            let thumbnailURL: String? = result["artworkUrl60"] as? String
            let imageURL: String? = result["artworkUrl100"] as? String
            let artistURL: String? = result["artistViewUrl"] as? String
            
            var itemURL: String? = result["collectionViewUrl"] as? String
            if !itemURL? {
                itemURL = result["trackViewUrl"] as? String
            }
            
            var newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL!, largeImageURL: imageURL!, itemURL: itemURL!, artistURL: artistURL!)
            albums.append(newAlbum)
        }
        dispatch_async(dispatch_get_main_queue(),{
            self.appsTableView.reloadData()
            })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsViewController: DetailsViewController =
    segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView.indexPathForSelectedRow().row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }
    
}
