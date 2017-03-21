//
//  OrderTableViewCell.swift
//  DeliveryScheduler
//
//  Created by Wendong Yang on 3/9/17.
//  Copyright © 2017 Wendong Yang. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var deliverTime: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
