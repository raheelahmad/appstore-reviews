//
//  RatingCells.swift
//  Scriviews
//
//  Created by Raheel Ahmad on 10/12/14.
//  Copyright (c) 2014 Sakun Labs. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell {
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
}

class RatingTitleCell: UITableViewCell {
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel_: UILabel!
}

class RatingTitleContentCell: UITableViewCell {
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel_: UILabel!
    @IBOutlet var contentLabel: UILabel!
}
