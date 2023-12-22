//
/**
* Webkul Software.
* @package  Mobikul Single App
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: ScanViewController.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import UIKit

 

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
var token = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scan Qr Code"
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
         00
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
            NetworkManager.sharedInstance.showLoader()
            var requstParams = [String: Any]()
             
            requstParams["storeId"] = Defaults.storeId
            requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        requstParams["token"] = self.token
            //http://192.168.15.127/Mage234/mobikul/qrcodelogin/savecustomertoken?customerToken=1iseg1fsdfdsf&token=7ncpbbqkd 
            
            //requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "notificationData"))
            
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .scanQr, currentView: UIViewController()) { [weak self] success, responseObject  in
                NetworkManager.sharedInstance.dismissLoader()
                if success == 1 {
                    let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
    //                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
    //                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "notificationData"))
    //                    }
    //
    //                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
    //                        completion(success)
    //                    }
                    } else {
                        if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                            ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                        } else {
                            ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                        }
                    }
                } else if success == 2 {   // Retry in case of error
                    NetworkManager.sharedInstance.dismissLoader()
                    self?.callingHttppApi {success in
                        completion(success)
                        
                    }
                } else if success == 3 {   // No Changes
                    let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "notificationData"))
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success)
                    }
                    
                }
            }
        }
        
        func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
           
            completion(true)
        }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
        token = code
        callingHttppApi {   (success) in
            if success {
              self.navigationController?.popViewController(animated: true)
            }
            
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
