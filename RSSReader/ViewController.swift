//
//  ViewController.swift
//  RSSReader
//
//  Created by susieyy on 2014/06/03.
//  Copyright (c) 2014年 susieyy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, MWFeedParserDelegate {
    
    var items: NSMutableArray = NSMutableArray()
    var data: NSMutableData = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func request() {
        SVProgressHUD.show()
        
        let URL = NSURL(string: "https://www.wantedly.com/projects.xml")
        var feedParser = MWFeedParser(feedURL: URL);
        feedParser.delegate = self
        feedParser.parse()
    }
    
    
    func feedParserDidFinish(parser: MWFeedParser) {
        SVProgressHUD.dismiss()
        self.tableView.reloadData()
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        println(info)
        self.title = info.title
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        println(item)
        println(item.link.componentsSeparatedByString("?")[0])        
        self.items.addObject(item)
    }

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 100
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FeedCell")
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        var con = KINWebBrowserViewController()
        let URL = NSURL(string: item.link)
        con.loadURL(URL)
        self.navigationController.pushViewController(con, animated:true)
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        cell.textLabel.text = item.title
        cell.textLabel.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel.numberOfLines = 0
        //cell.image = UIImage(named: "logo.png")
        
        
        var projectURL = item.link.componentsSeparatedByString("?")[0]
        var imgURL: NSURL = NSURL(string: projectURL + "/cover_image?style=s_100")
        
        // Download an NSData representation of the image at the URL
        //var imgData: NSData = NSData(contentsOfURL: imgURL)
        //cell.image = UIImage(data: imgData)
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView.setImageWithURL(imgURL, placeholderImage:UIImage(named: "logo.png"))
    }

}

