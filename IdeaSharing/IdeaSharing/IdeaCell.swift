//
//  IdeaCell.swift
//  
//
//  Created by Nikhil Kulkarni on 6/24/15.
//
//

import UIKit
import Parse

class IdeaCell: UITableViewCell {
    
    
    @IBOutlet var ideaLabel: UILabel!
    @IBOutlet var upvoteCount: UILabel!
    var upvotes:NSNumber = 0
    var objectID:String!
    
    let query = PFQuery(className: "Ideas")
    
    @IBAction func upVote(sender: AnyObject) {
        query.getObjectInBackgroundWithId(objectID, block: { (object:PFObject?, error:NSError?) -> Void in
            object?.incrementKey("upvotes")
            object?.saveInBackground()
            self.upvotes = self.upvotes.integerValue + 1
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.upvoteCount.text = "\(self.upvotes)"
            })
            
        })
    }
    
    @IBAction func downVote(sender: AnyObject) {
        query.getObjectInBackgroundWithId(objectID, block: { (object:PFObject?, error:NSError?) -> Void in
            object?.incrementKey("upvotes", byAmount: -1)
            object?.saveInBackground()
            self.upvotes = self.upvotes.integerValue - 1
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.upvoteCount.text = "\(self.upvotes)"
            })
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
