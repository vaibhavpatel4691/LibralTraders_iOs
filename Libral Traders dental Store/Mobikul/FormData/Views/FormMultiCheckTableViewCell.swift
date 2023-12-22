//
/**
* Webkul Software.
* @package  Mustalem
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: FormMultiCheckTableViewCell.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import UIKit
import Reusable

class FormMultiCheckTableViewCell: UITableViewCell, FormConformity, NibReusable  {
    var formItem: FormItem?
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension FormMultiCheckTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.formItem?.multiData.count ?? 0
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    //        cell.textLabel?.text =  self.formItem?.multiData[indexPath.row].label ?? ""
    //        return cell
    //    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.formItem?.heading ?? ""
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        cell.textLabel?.text = self.formItem?.multiData[indexPath.row].label ?? ""
         if Defaults.language == "ar" {
            cell.textLabel?.textAlignment = .right
         } else {
            cell.textLabel?.textAlignment = .left
        }
        if self.formItem?.multiData[indexPath.row].check ?? false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.formItem?.multiData[indexPath.row].check ?? false {
            self.formItem?.multiData[indexPath.row].check = false
        } else {
            self.formItem?.multiData[indexPath.row].check = true
        }
        table.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension FormMultiCheckTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        height.constant = CGFloat(((self.formItem?.multiData.count ?? 0) * 50) + 40)
        table.delegate = self
        table.dataSource = self
        table.reloadData()
    }
}
