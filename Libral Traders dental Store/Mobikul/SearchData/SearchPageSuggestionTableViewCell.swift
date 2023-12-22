//
//  SearchPageSuggestionTableViewCell.swift
//  Mobikul Single App
//
//  Created by jitendra on 11/08/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit

class SearchPageSuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var specialPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
