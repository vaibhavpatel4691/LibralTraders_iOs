//
//  CountryTableViewCell.swift
//  AKN
//
//  Created by khushboo on 15/02/23.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
