//
//  OrderTrackViewController.swift
//  Libral Traders
//
//  Created by Invention Hill on 18/10/23.
//

import UIKit
import BottomPopup


class OrderTrackViewController: UIViewController {

    
    // MARK: - BottomPopupAttributesDelegate Variables

    @IBOutlet weak private var trackStackView: UIStackView!
    @IBOutlet weak private var carriesStackView: UIStackView!
    @IBOutlet weak private var statusStackView: UIStackView!
    @IBOutlet weak private var typeStackView: UIStackView!
    @IBOutlet weak private var dateStackView: UIStackView!
    @IBOutlet weak private var timeStackView: UIStackView!
    @IBOutlet weak private var destinationStackView: UIStackView!
    @IBOutlet weak private var originStackView: UIStackView!
    @IBOutlet weak private var orderTrackTableView: UITableView!
    @IBOutlet weak var lblTrackingNumber: UILabel!
    @IBOutlet weak var lblCarries: UILabel!
    @IBOutlet weak var lblOrigin: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblBookingDate: UILabel!
    @IBOutlet weak var lblBookingTime: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    let viewModel = OrderListViewModel()
    var shipmentId: String?
    var incrementId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderTrackTableView.delegate = self
        self.orderTrackTableView.dataSource = self
        // Do any additional setup after loading the view.
//        self.setUpView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sharp-cross")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backPress))
        self.navigationItem.title = "Shipment - #\(self.incrementId ?? "")"
        self.appTheme()
        self.callTrackOrderRequest(shipmentID: self.shipmentId ?? "")
    }
    
    func setOrderData() {
        let details = self.viewModel.trackOrderData.first
        if let trackingNumber = details?.carrier_title, !trackingNumber.isEmpty {
            trackStackView.isHidden = false
            lblTrackingNumber.text = trackingNumber
        } else {
            trackStackView.isHidden = true
        }

        // Check lblCarries
        if let carries = details?.tracking_number, !carries.isEmpty {
            carriesStackView.isHidden = false
            lblCarries.text = carries
        } else {
            carriesStackView.isHidden = true
        }

        // Check lblOrigin
        if let origin = details?.ORIGIN, !origin.isEmpty {
            originStackView.isHidden = false
            lblOrigin.text = origin
        } else {
            originStackView.isHidden = true
        }

        // Check lblDestination
        if let destination = details?.DESTINATION, !destination.isEmpty {
            destinationStackView.isHidden = false
            lblDestination.text = destination
        } else {
            destinationStackView.isHidden = true
        }

        // Check lblBookingDate
        if let bookingDate = details?.BOOKING_DATE, !bookingDate.isEmpty {
            dateStackView.isHidden = false
            lblBookingDate.text = bookingDate
        } else {
            dateStackView.isHidden = true
        }

        // Check lblBookingTime
        if let bookingTime = details?.BOOKING_TIME, !bookingTime.isEmpty {
            timeStackView.isHidden = false
            lblBookingTime.text = bookingTime
        } else {
            timeStackView.isHidden = true
        }
        
        // Check lblType
        if let type = details?.SERVICE_TYPE, !type.isEmpty {
            typeStackView.isHidden = false
            lblType.text = type
        } else {
            typeStackView.isHidden = true
        }

        // Check lblStatus
        if let status = details?.CURRENT_STATUS, !status.isEmpty {
            statusStackView.isHidden = false
            lblStatus.text = status
        } else {
            statusStackView.isHidden = true
        }
    }
    
    func appTheme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                

            } else {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             
         }
        } else {
           UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]

        }
    }
    
//    func setUpView() {
//        DispatchQueue.main.async {
//            self.trackImageView1.layer.cornerRadius = self.trackImageView1.frame.size.height/2
//            self.trackImageView2.layer.cornerRadius = self.trackImageView2.frame.size.height/2
//            self.trackImageView3.layer.cornerRadius = self.trackImageView3.frame.size.height/2
//            self.trackImageView4.layer.cornerRadius = self.trackImageView4.frame.size.height/2
//        }
//        self.setTrackProgress(progress: 0.60)
//        viewModel = OrderListViewModel()
      
//
//        self.noRecordFoundLabel.isHidden = shipmentId?.count ?? 0 > 0 ? true : false
//        self.trackView.isHidden = shipmentId?.count ?? 0 > 0 ? false : true
//    }

//    private func setTrackProgress(progress: Float = 0.0) {
//        self.trackImageView1.backgroundColor = .green
//        self.trackImageView2.backgroundColor = AppStaticColors.startEmptyColor
//        self.trackImageView3.backgroundColor = AppStaticColors.startEmptyColor
//        self.trackImageView4.backgroundColor = AppStaticColors.startEmptyColor
//        //self.trackView1.progress = 0.10
//        trackView1.animateProgress(to: 0.5, duration: 2.0)
//    }
}

extension OrderTrackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.trackOrderData.first?.orderObject?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTrackCell.identifier, for: indexPath) as? OrderTrackCell else {
            return UITableViewCell()
        }
        
        let detail = self.viewModel.trackOrderData.first?.orderObject?[indexPath.row]
        cell.configOrderTrackCell(details: detail)
        
        return cell
    }    
}

extension OrderTrackViewController {
    
    func callTrackOrderRequest(shipmentID: String) {
        self.viewModel.trackOrderHttppApi(shipmentId: shipmentID) { [weak self] success in
            guard let self = self else { return }
            if success {
                
                self.orderTrackTableView.reloadData()
                self.setOrderData()
            } else {
                print("cancel...error....")
            }
        }
    }
}

class OrderTrackCell: UITableViewCell {
    
    @IBOutlet weak private var lblCurrentStatus: UILabel!
    @IBOutlet weak private var lblCurrentCity: UILabel!
    @IBOutlet weak private var lblEventDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configOrderTrackCell(details:  OrderObject?) {
        self.lblCurrentStatus.text = details?.delivery
        self.lblCurrentCity.text = details?.name
        self.lblEventDate.text = details?.date
    }
}
