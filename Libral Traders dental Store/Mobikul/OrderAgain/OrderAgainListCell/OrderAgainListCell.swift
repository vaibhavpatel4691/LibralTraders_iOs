//
//  OrderAgainListCell.swift
//  Libral Traders
//
//  Created by Invention Hill on 02/10/23.
//

import UIKit

class OrderAgainListCell: UITableViewCell {

    @IBOutlet weak var lblOrderQuantity: UILabel!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var availableStatusLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var statusBackGroundView: UIView!
    
    @IBOutlet weak var buyAgainButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    var count = 1
    weak var delegate: moveToControlller?
    var updateStepperCount: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.availableStatusLabel.layer.cornerRadius = 4
        self.availableStatusLabel.borderWidth1 = 1
        self.availableStatusLabel.borderColor1 = UIColor.black
        self.orderStatusLabel.textColor = .black
        self.buyAgainButton.layer.cornerRadius = 4
        self.statusBackGroundView.layer.cornerRadius = self.statusBackGroundView.frame.size.height/2
        
        self.availableStatusLabel.isHidden = true
        self.offerLabel.isHidden = true
    }

    func didSetData() {
//        self.buyAgainButton.backgroundColor = UIColor(named: "primary") ?? .white
//        self.statusBackGroundView.backgroundColor = UIColor(named: "primary") ?? .white
    }
    
    @IBAction func btnRemove(_ sender: Any) {
        if count > 0 {
            count -= 1
            lblOrderQuantity.text = "\(count)"
            self.updateStepperCount?()
        }
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        count += 1
        lblOrderQuantity.text = "\(count)"
        self.updateStepperCount?()
    }
    
    func configOrderAgainCell(item: ReOrderListDataStruct, callback: @escaping (ReOrderListDataStruct) -> ()) {
        DispatchQueue.main.async {
            self.statusBackGroundView.layer.cornerRadius = self.statusBackGroundView.frame.size.height/2
        }
        
        self.productImageView.setImage(fromURL: item.image)
        orderStatusLabel.text = item.product_type ?? ""
        let orderQuantity = Double(item.qty_order ?? "0.0")
        count = Int(orderQuantity ?? 0.0)
        lblOrderQuantity.text = count.description
        
        orderDateLabel.text = item.create_at ?? ""
        priceLabel.text = item.price ?? ""
        productTitleLabel.text = item.name
        
        self.updateStepperCount = {
            item.qty_order = self.lblOrderQuantity.text
            callback(item)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buyAgainButtonPressed(_ sender: UIButton) {
        delegate?.moveController(id: "", name: sender.titleLabel?.text ?? "", dict: [:], jsonData: JSON.null, index: sender.tag, controller: .reOrder)
    }
}
