//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CustomTextFieldTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import ARKit

class CustomTextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var headinglabel: UILabel!
    var customDict = [String: Any]()
    var parentID = ""
    weak var delegate: GettingCustomData?
    var valueClosure:((String)->Void)?
    var textFieldCloure:((String)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        // Initialization code
        self.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    override func layoutSubviews() {
        if let obj = self.viewContainingController as? ProductPageDataViewController, let viewModel = obj.viewModel {
            self.customDict = viewModel.customDict
        }
        if let val = customDict[parentID] as? String {
            textField.text = val
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        print(textField.text)
        print(customDict)
    }
    
    var item: CustomOptions!{
        didSet{
            if item.isAr{
                setBtutonOnTextField()
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension CustomTextFieldTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let obj = self.viewContainingController as? ProductPageDataViewController, let viewModel = obj.viewModel {
            self.customDict = viewModel.customDict
        }
        customDict[parentID] = textField.text
        delegate?.gettingCustomData(data: customDict)
    }
    func setBtutonOnTextField(){
           let button = UIButton(type: .custom)
            self.textField.textContentType = UITextContentType(rawValue: "")
            button.setImage(UIImage(named: "icon-ar"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.backgroundColor = UIColor.white
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.OpenArMeasure), for: .touchUpInside)
            button.tag = Int(parentID) ?? 0
            print(button.tag)
            self.textField.rightView = button
            self.textField.rightViewMode = .always
        }
        
        @objc func OpenArMeasure(_ sender: UIButton) {
            
            if ARConfiguration.isSupported {
                if let view = self.findViewController(){
                     let viewController = ARMeasureViewController.instantiate(fromAppStoryboard: .arStoryboard)
                     viewController.valueClosure = valueClosure
    //                viewController.valueClosure = { arMeasure in
    //                        if let obj = self.viewContainingController as? ProductPageDataViewController, let viewModel = obj.viewModel {
    //                           self.customDict = viewModel.customDict
    //                       }
    ////                    self.textField.text = arMeasure
    //                    print(sender.tag)
    //                    self.parentID = String(sender.tag)
    //                    self.customDict[self.parentID] = arMeasure
    //                    self.delegate?.gettingCustomData(data: self.customDict)
    //                }
                     viewController.modalPresentationStyle = .fullScreen
                     view.present(viewController, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "ARKit is not supported. You cannot work with ARKit".localized, message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
                alert.addAction(ok)
                if let view = self.findViewController(){
                    view.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
        func findViewController()->ProductPageDataViewController?{
            if let view = self.viewContainingController as? ProductPageDataViewController{
                return view
            }
            return nil
        }
    }

