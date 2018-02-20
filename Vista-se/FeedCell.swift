//
//  FeedCell.swift
//  RSSReader
//
//  Created by Ezequiel on 18/02/18.
//  Copyright © 2018 susieyy. All rights reserved.
//

import UIKit
import MWFeedParser

class FeedCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txt: UILabel!
    @IBOutlet weak var date: UILabel!
    
    public func configureCell(indexPath: IndexPath, items:[MWFeedItem], images:[URL]) {
        let item = items[indexPath.row]
        self.txt.text = item.title
        self.date.text = item.date.stringValue()
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
//        cell.textLabel?.numberOfLines = 0
        let imgURL = images[indexPath.row]
        //self.img.contentMode = UIViewContentMode.scaleToFill
        self.img.setImageWith(imgURL, placeholderImage: UIImage(named: "logo.png"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
