//
//  ViewController.swift
//  RSSReader
//
//  Created by susieyy on 2014/06/03.
//  Copyright (c) 2014年 susieyy. All rights reserved.
//

import UIKit
import MWFeedParser
import SVProgressHUD
import KINWebBrowser

class ViewController: UITableViewController, MWFeedParserDelegate {
    
    var items = [MWFeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func request() {
        let url = URL(string: "https://www.wantedly.com/projects.xml")
        let feedParser = MWFeedParser(feedURL: url)
        feedParser?.delegate = self
        feedParser?.parse()
    }
    
    func feedParserDidStart(_ parser: MWFeedParser) {
        SVProgressHUD.show()
        self.items = [MWFeedItem]()
    }

    func feedParserDidFinish(_ parser: MWFeedParser) {
        SVProgressHUD.dismiss()
        self.tableView.reloadData()
    }
    
    
    func feedParser(_ parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        print(info)
        self.title = info.title
    }
    
    func feedParser(_ parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        print(item)
        self.items.append(item)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "FeedCell")
        self.configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        let con = KINWebBrowserViewController()
        let url = URL(string: item.link)
        con.load(url)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        cell.textLabel?.text = item.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.numberOfLines = 0
        
        let projectURL = item.link.components(separatedBy: "?")
        let imgURL: URL? = URL(string: "\(projectURL) + \("/cover_image?style=200x200#")")
        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cell.imageView?.setImageWith(imgURL, placeholderImage: UIImage(named: "logo.png"))
    }
}

