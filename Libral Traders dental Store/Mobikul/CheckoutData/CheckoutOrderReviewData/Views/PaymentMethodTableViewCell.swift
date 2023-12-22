//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: PaymentMethodTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodHeading: UILabel!
    private var paymentMethods = [PaymentMethods]()
    var paymentId = ""
    weak var delegate: SendPaymentId?
    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodHeading.text = "Payment Method".localized
        tableView.register(cellType: SelectionMethodTableViewCell.self)
        tableView.separatorStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var paymentMethod: [PaymentMethods]! {
        didSet {
            let payments = paymentMethod.filter {(PaymentData.supportedPaymnets.contains($0.code))}
            self.paymentMethods = payments
            self.tableViewHeight.constant = CGFloat(56 * paymentMethods.count)
            //            let selectedPaymemntData = payments.filter({$0.code == paymentId})
            //            if let data = selectedPaymemntData.first?.extraInformation {
            //                if !(data.isEmpty) {
            //                    let height = data.height(withConstrainedWidth: AppDimensions.screenWidth - 72, font: UIFont.systemFont(ofSize: 12.0))
            //                    self.tableViewHeight.constant = CGFloat(56 * paymentMethods.count) + height
            //
            //                }
            //            }
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
}

extension PaymentMethodTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SelectionMethodTableViewCell = tableView.dequeueReusableCell(with: SelectionMethodTableViewCell.self, for: indexPath) {
            cell.methodName.text = paymentMethods[indexPath.row].title
            cell.theme()
            if paymentId == paymentMethods[indexPath.row].code {
                cell.internalImageView.backgroundColor = AppStaticColors.accentColor
            } else {
                //cell.internalImageView.backgroundColor = UIColor.white
                if #available(iOS 12.0, *) {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        cell.internalImageView.backgroundColor = UIColor.black
                    } else {
                        cell.internalImageView.backgroundColor = UIColor.white
                    }
                } else {
                    cell.internalImageView.backgroundColor = UIColor.white
                }
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymentId = paymentMethods[indexPath.row].code
        //delegate?.sendPaymentId(paymentId: paymentId)
        delegate?.sendPaymentId(paymentData: paymentMethods[indexPath.row])
        //        if paymentMethods[indexPath.row].webview {
        //            if !PaymentData.webviewSupportedPaymnets.contains(paymentMethods[indexPath.row].code) {
        //                PaymentData.webviewSupportedPaymnets.append(paymentMethods[indexPath.row].code)
        //            }
        //            PaymentData.webViewPaymentURL = paymentMethods[indexPath.row].redirectUrl ?? ""
        //            PaymentData.webviewPaymentSuccessKeys = paymentMethods[indexPath.row].successUrl ?? []
        //            PaymentData.webviewPaymentCancelKeys = paymentMethods[indexPath.row].cancelUrl ?? []
        //            PaymentData.webviewPaymentFailureKeys = paymentMethods[indexPath.row].failureUrl ?? []
        //        }
        self.tableView.reloadData()
    }
    
}

protocol SendPaymentId: NSObjectProtocol {
    func sendPaymentId(paymentData: PaymentMethods)
}
