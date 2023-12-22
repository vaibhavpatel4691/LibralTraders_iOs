//
//  OrderCancelVC.swift
//  Libral Traders
//
//  Created by Invention Hill on 05/10/23.
//

import UIKit
import BottomPopup
import iOSDropDown

class OrderCancelVC: BottomPopupViewController, UITextViewDelegate {

    
    var orderID: String?
    let placeholderLabel = UILabel()
    @IBOutlet weak var selectReasonTextField: DropDown!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var viewModel: OrderListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()

        selectReasonTextField.optionArray = ["I m not at home", "I placed a wrong order", "I forgot to add additional products/items", "Others"]
        
       
    }
    
    // MARK: - BottomPopupAttributesDelegate Variables
    override var popupHeight: CGFloat { 450.0 }
    override var popupTopCornerRadius: CGFloat { 10.0 }
    override var popupPresentDuration: Double { 0.3 }
    override var popupDismissDuration: Double { 0.3 }
    override var popupShouldDismissInteractivelty: Bool { true }
    override var popupDimmingViewAlpha: CGFloat { 0.5 }

    
    func setUpView() {
        
        viewModel = OrderListViewModel()
        self.submitButton.borderWidth1 = 1
        self.submitButton.borderColor1 = UIColor().hexToColor(hexString: "8BC34A")
        self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height/2
        self.commentTextView.borderWidth1 = 0.1
        self.commentTextView.layer.cornerRadius = 4
        
        // The the Closure returns Selected Index and String
        selectReasonTextField.didSelect{(selectedText , index ,id) in
        self.selectReasonTextField.text = selectedText
            print("Selected String: \(selectedText) \n index: \(index)")
        }
        self.selectReasonTextField.selectedRowColor = .clear
        
        
        commentTextView.text = ""
        placeholderLabel.text = "Write a comment"
       // placeholderLabel.font = UIFont.italicSystemFont(ofSize: (noteTextView.font?.pointSize)!)
       // placeholderLabel.font = UIFont(name: "Inter-Regular", size: (commentTextView.font?.pointSize)!)
        placeholderLabel.font = UIFont.systemFont(ofSize: commentTextView.font!.pointSize)
        placeholderLabel.sizeToFit()
        commentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (commentTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !commentTextView.text.isEmpty
        
        // Set the delegate to track changes
        commentTextView.delegate = self
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if selectReasonTextField.text == "" {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please select cancel reason".localized)
        } else if commentTextView.text == "" {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please enter comment".localized)
        } else {
            guard let id = orderID else { ShowNotificationMessages.sharedInstance.warningView(message: "Order id not found".localized)
                return
            }
            callCancelOrderRequest(orderId: id, reason: selectReasonTextField.text!, comment: commentTextView.text)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}

extension OrderCancelVC {
    
    func callCancelOrderRequest(orderId: String, reason: String, comment: String) {
        viewModel?.cancelOrderHttppApi(orderID: orderId, cancelReason: reason, comment: comment) { [weak self] success in
            guard let self = self else { return }
            if success {
                print("cancel...sucess....")
                dismiss(animated: true, completion: nil)
            } else {
                print("cancel...error....")
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
