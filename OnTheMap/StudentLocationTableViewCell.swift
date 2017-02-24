//
//  StudentLocationTableViewCell.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/20/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell
{
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaUrlLabel: UILabel!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        locationImageView.image = locationImageView.image?.withRenderingMode(.alwaysTemplate)
    }
}
