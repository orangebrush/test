//
//  PolicyCell0.swift
//  government_park
//
//  Created by YiGan on 27/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class PolicyImageCell: UITableViewCell {
    
    @IBOutlet weak var headImageView: UIImageView!
}

class PolicyTitleCell: UITableViewCell {
    
}

class PolicySingleLineCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
}

class PolicyMuteLineCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}
