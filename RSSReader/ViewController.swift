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
    var images = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(FeedCell.self, forCellReuseIdentifier: "FeedCell")
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
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
        let url = URL(string: "https://www.vista-se.com.br/feed")
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
        print(info.title)
        self.title = info.title
    }
    
    func feedParser(_ parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
//        NSString *identifier; // Item identifier
//        NSString *title; // Item title
//        NSString *link; // Item URL
//        NSDate *date; // Date the item was published
//        NSDate *updated; // Date the item was updated if available
//        NSString *summary; // Description of item
//        NSString *content; // More detailed content (if available)
//        NSString *author; // Item author
//        print("IDENTIFIER")
//        print(item.identifier)
//         print("TITLE")
//        print(item.title)
//         print("LINK")
//        print(item.link)
//         print("DATE")
//        print(item.date)
//         print("UPDATED")
//        print(item.updated)
//         print("SUMMARY")
//        print(item.summary)
//         print("CONTENT")
//        print(item.content)
        if let imgURL = item.content.extractURLs().first {
            images.append(imgURL)
        } else {
            images.append(URL(string: "https://www.vista-se.com.br/docs/logo.jpg")!)
        }
        self.items.append(item)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.configureCell(indexPath: indexPath, items: self.items, images: self.images)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        let con = KINWebBrowserViewController()
        let url = URL(string: item.link)
        con.load(url)
        self.navigationController?.pushViewController(con, animated: true)
    }
}

extension String {
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}

extension Date {
    func stringValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter.string(from: self)
    }
    
    func brazilianTimeZoneDate() -> Date {
        let myLocale = Locale(identifier: "pt_BR")
        if let myTimezone = TimeZone(identifier: "GMT") {
            print("\(myTimezone.identifier)")
        }
        let formatter = DateFormatter()
        formatter.locale = myLocale
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let dateStr = formatter.string(from: self)
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = myLocale
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: self)
        _ = calendar.monthSymbols[dateComponents.month! - 1]
        if let componentsBasedDate = calendar.date(from: dateComponents) {
            let componentsBasedDateStr = formatter.string(from: componentsBasedDate)
            print("3. \(componentsBasedDateStr)")
        }
        return formatter.date(from: dateStr) ?? Date()
    }
}

