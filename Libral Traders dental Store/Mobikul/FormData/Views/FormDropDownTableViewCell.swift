//
//  FormDropDownTableViewCell.swift
//  MobikulOpencartMp
//
//  Created by bhavuk.chawla on 05/11/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import Reusable
import ActionSheetPicker_3_0
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTypographyScheme

class FormDropDownTableViewCell: UITableViewCell, FormConformity, NibReusable {
    
    @IBOutlet weak var stateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stateTextField: MDCTextField!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var textField: MDCTextField!
    var fieldController: MDCTextInputControllerOutlined!
    var fieldController1: MDCTextInputControllerOutlined!
    var tableView: UITableView?
    var formItem: FormItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldController = MDCTextInputControllerOutlined(textInput: textField)
        fieldController.activeColor = AppStaticColors.accentColor
        fieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        
        fieldController1 = MDCTextInputControllerOutlined(textInput: stateTextField)
        fieldController1.activeColor = AppStaticColors.accentColor
        fieldController1.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        
        self.stateView.isHidden = true
        self.stateViewHeight.constant = 0
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        stateTextField.delegate = self
        theme()
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCountryView)))
        stateTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStateView)))
        //            self.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.formItem?.valueCompletion?(textField.text)
    }
    func theme() {
        if #available(iOS 12.0, *) {
                  if self.traitCollection.userInterfaceStyle == .dark {
                      textField.textColor = UIColor.white
                      stateTextField.textColor = UIColor.white
                      fieldController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                      fieldController.inlinePlaceholderColor = AppStaticColors.accentColor
                    fieldController1.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                    fieldController1.inlinePlaceholderColor = AppStaticColors.accentColor
                  } else {
                     textField.textColor = AppStaticColors.accentColor
                     stateTextField.textColor = AppStaticColors.accentColor
                  }
              } else {
                  textField.textColor = AppStaticColors.accentColor
                  stateTextField.textColor = AppStaticColors.accentColor
              }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc private func didTapStateView() {
        if let formItem = formItem, let countryData = formItem.countryData as? [CountryData],
            let val1 = self.formItem?.value as? String,
            let index = countryData.firstIndex(where: {$0.countryId == val1 }) {
            //              let countryData = formItem.countryData[index]
            var rowValue = 0
            if let val = self.formItem?.value2 as? String, let index = countryData[index].states.firstIndex(where: {$0.regionId == val }) {
                rowValue = index
            }
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    
                    
                    UIBarButtonItem.appearance().tintColor = AppStaticColors.darkItemTintColor
                } else {
                    
                   UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
                }
            } else {
                
                UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
            }
            let gg =   ActionSheetStringPicker(title: formItem.placeholder2, rows: countryData[index].states.map { $0.name }, initialSelection: rowValue, doneBlock: { _, indexes, _ in
                self.stateTextField.text = countryData[index].states[indexes].name
                formItem.value2 = countryData[index].states[indexes].regionId
                return
            }, cancel: { _ in
                
                return }, origin: self.textField)
            gg?.setCancelButton(UIBarButtonItem.init(title: "Cancel".localized, style: .done, target: self, action: nil))
            gg?.setDoneButton(UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: nil))
            if #available(iOS 12.0, *) {
                       if self.traitCollection.userInterfaceStyle == .dark {
                          
                       
                        gg?.toolbarBackgroundColor = UIColor.white
                       } else {
                        
                        gg?.toolbarBackgroundColor = UIColor.white
                       }
            } else {
                 
                gg?.toolbarBackgroundColor = UIColor.white
            }
            gg?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//this is actually the title of toolbar
            gg?.toolbarButtonsColor = UIColor.blue
            
            gg?.show()
        }
    }
    
    @objc private func didTapCountryView() {
        if let formItem = formItem, let val = formItem.countryData as? [CountryData] {
            var rowValue = 0
            if  let val1 = self.formItem?.value as? String,
                let index = val.firstIndex(where: {$0.countryId == val1 }) {
                rowValue = index
            }
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    
                    
                    UIBarButtonItem.appearance().tintColor = AppStaticColors.darkItemTintColor
                } else {
                    
                   UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
                }
            } else {
                
                UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
            }
            
            //            ActionSheetStringPicker(
            
            let gg =  ActionSheetStringPicker(title: formItem.placeholder, rows: val.map { $0.name }, initialSelection: rowValue, doneBlock: { _, indexes, _ in
                self.textField.text = val[indexes].name
                formItem.value = val[indexes].countryId
                if  val[indexes].states.count > 0 {
                    self.stateTextField.text = val[indexes].states[0].name
                    formItem.value2 = val[indexes].states[0].regionId
                    self.stateView.isHidden = false
                    self.stateViewHeight.constant = 70
                    self.formItem?.valueCompletion?("data")
                    self.tableView?.reloadData()
                } else {
                    formItem.value2 = nil
                    self.stateView.isHidden = true
                    self.stateViewHeight.constant = 0
                    self.formItem?.valueCompletion?("")
                    self.tableView?.reloadData()
                }
                
            }, cancel: { _ in
                
                return }, origin: self.textField)
            
            //            toolbar?.setCancelButton(UIBarButtonItem.init(title: "PICKER_Cancel".localized, style: .done, target: self, action: nil))
            gg?.setCancelButton(UIBarButtonItem.init(title: "Cancel".localized, style: .done, target: self, action: nil))
            gg?.setDoneButton(UIBarButtonItem.init(title: "Done".localized, style: .done, target: self, action: nil))
            if #available(iOS 12.0, *) {
                       if self.traitCollection.userInterfaceStyle == .dark {
                          
                       
                        gg?.toolbarBackgroundColor = UIColor.white
                       } else {
                        
                        gg?.toolbarBackgroundColor = UIColor.white
                       }
            } else {
                 
                gg?.toolbarBackgroundColor = UIColor.white
            }
            gg?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//this is actually the title of toolbar
            gg?.toolbarButtonsColor = UIColor.blue
            
            gg?.show()
        }
    }
}

extension FormDropDownTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
}

extension FormDropDownTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        self.textField.isSecureTextEntry = formItem.isSecure
        if let val = self.formItem?.value as? String, let countryData = formItem.countryData as? [CountryData], let index = countryData.firstIndex(where: {$0.countryId == val }) {
            self.textField.text =  countryData[index].name
            let selectedCountryData = countryData[index]
            if let val = self.formItem?.value2 as? String,
                let index = selectedCountryData.states.firstIndex(where: {($0.regionId == val) || ($0.code == val) }) {
                let stateData = selectedCountryData.states
                self.stateView.isHidden = false
                self.stateViewHeight.constant = 70
                self.stateTextField.text = stateData[index].name
                self.formItem?.valueCompletion?("dataFirstHitApi")
            } else {
                if countryData[index].states.count > 0 {
                    self.stateView.isHidden = false
                    self.stateViewHeight.constant = 70
                    let stateData = countryData[index].states[0]
                    formItem.value2 = stateData.regionId
                    self.stateTextField.text = stateData.name
                    self.formItem?.valueCompletion?("dataFirstHitApi")
                } else {
                    self.stateView.isHidden = true
                    self.stateViewHeight.constant = 0
                    self.formItem?.valueCompletion?("firstHit")
                }
            }
        } else {
            if formItem.countryData.count > 0 {
                if let countryData = formItem.countryData[0] as? CountryData {
                    self.textField.text =  countryData.name
                    formItem.value = countryData.countryId
                    
                    if countryData.states.count > 0 {
                        self.stateView.isHidden = false
                        self.stateViewHeight.constant = 70
                        let stateData = countryData.states[0]
                        formItem.value2 = stateData.regionId
                        self.stateTextField.text = stateData.name
                        self.formItem?.valueCompletion?("dataFirstHitApi")
                    } else {
                        self.stateView.isHidden = true
                        self.stateViewHeight.constant = 0
                        self.formItem?.valueCompletion?("firstHit")
                    }
                }
                
            }
        }
        //        self.textField.text =
        self.textField.accessibilityHint = self.formItem?.keyType
        
        if let image = formItem.rightIcon {
            self.textField.setRightIcon(image)
        }
        
        if let image = formItem.rightIcon {
            self.stateTextField.setRightIcon(image)
        }
        
        self.stateTextField.placeholder =  self.formItem?.placeholder2
        self.textField.placeholder = self.formItem?.placeholder
        self.textField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
        self.textField.tintColor = self.formItem?.uiProperties.tintColor
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                
                
                UIBarButtonItem.appearance().tintColor = AppStaticColors.darkItemTintColor
            } else {
                
                UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
            }
        } else {
            
            UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
        }
        theme()
    }
}

extension UITextField {
    
    /// set icon of 20x20 with left padding of 8px
    func setRightIcon(_ icon: UIImage) {
        
//        let padding = 8
//        let size = 16
//
//        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
//        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
//        iconView.image = icon
//        outerView.addSubview(iconView)
//
//        rightView = outerView
//        rightViewMode = .always
        
//        let size: CGFloat = 16
//        let outerView = UIView()
//        outerView.translatesAutoresizingMaskIntoConstraints = false
//        outerView.widthAnchor.constraint(equalToConstant: size).isActive = true
//        outerView.heightAnchor.constraint(equalToConstant: size).isActive = true
//
//        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
//        iconView.image = icon
//        iconView.contentMode = .scaleAspectFit
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        outerView.addSubview(iconView)
//
//        iconView.topAnchor.constraint(equalTo: outerView.topAnchor).isActive = true
//        iconView.leftAnchor.constraint(equalTo: outerView.leftAnchor).isActive = true
//        iconView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor).isActive = true
//
//        rightView = outerView
//        rightViewMode = .always
        
        let size: CGFloat = 16
        let iconView = UIButton(type: .custom)
        iconView.isUserInteractionEnabled = false
        iconView.setImage(icon, for: .normal)
        iconView.backgroundColor = UIColor.white
        iconView.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        iconView.frame = CGRect(x: self.frame.size.width - size, y: CGFloat(5), width: size, height: size)
        rightView = iconView
        rightViewMode = .always
    }
}
