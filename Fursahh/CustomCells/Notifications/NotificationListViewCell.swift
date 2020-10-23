//
//  NotificationListViewCell.swift
//  Fursahh
//
//  Created by Akber Sayni on 08/07/2019.
//  Copyright © 2019 Akber Sayani. All rights reserved.
//

import UIKit

class NotificationListViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(_ data: NotificationModel) {
        self.titleLabel.text = data.title
        self.messageLabel.text = data.message
        if let dateTime = data.dateTime {
            self.dateLabel.text = Utility.getFormattedDateFromString(dateTime, withFormat: "dd MMM yyyy")
        }
    }
}
