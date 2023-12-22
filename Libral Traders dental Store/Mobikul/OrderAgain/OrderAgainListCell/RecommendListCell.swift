//
//  OrderAgainListCell.swift
//  Libral Traders
//
//  Created by Invention Hill on 02/10/23.
//

import UIKit

class RecommendListCell: UITableViewCell {

    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var brnadNameLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noReviewYetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.stockLabel.layer.cornerRadius = 4
        self.stockLabel.borderWidth1 = 1
        self.stockLabel.borderColor1 = UIColor.black
        
        self.addButton.layer.cornerRadius = 4
        self.ratingButton.layer.cornerRadius = self.ratingButton.frame.size.height/2
       
        self.offerLabel.backgroundColor = AppStaticColors.primaryColor
       // self.contentView.backgroundColor = AppStaticColors.primaryColor
        // Set the title for the button
        ratingButton.setTitle("3.5", for: .normal)
        ratingButton.semanticContentAttribute = .forceRightToLeft
        ratingButton.contentHorizontalAlignment = .center
        // Set the image for the button
//        let image = UIImage(named: "imageName")
//        button.setImage(image, for: .normal)
//
//        // Set the position of the image relative to the title
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
}
