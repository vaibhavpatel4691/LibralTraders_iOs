//
//  PngModelViewController.swift
//  The Mall Of Afrika
//
//  Created by ranjit on 03/06/20.
//  Copyright © 2020 ranjit. All rights reserved.
//

import UIKit
import AVFoundation
class PngModelViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    let captureSession = AVCaptureSession()
        var previewLayer: AVCaptureVideoPreviewLayer!
        var captureDevice: AVCaptureDevice!
        var arUrl = ""
        override func viewDidLoad() {
            super.viewDidLoad()
             prepareCamera()
            self.spawnImage()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
         
        func spawnImage() {
            // let image = UIImage(named: "phone_box")
            let url = URL(string: arUrl)!
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { [weak self] in
                    let image  = UIImage(data: data)
                    let imageView = SOXPanRotateZoomImageView(image: image)
                    imageView.backgroundColor = UIColor.clear
                    if let cen = self?.view.center {
                        imageView.center = cen
                    }
                    self?.view.addSubview(imageView)
                }
            }
            
        }
    
        
    @IBAction func backBtnAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
        func prepareCamera() {
            captureSession.sessionPreset = AVCaptureSession.Preset.medium
            if #available(iOS 10.0, *) {
                captureDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back).devices.first
            } else {
                // Fallback on earlier versions
            }
            beginSession()
        }
        
        func beginSession() {
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(captureDeviceInput)
            } catch {
                print(error.localizedDescription)
                presentCameraSettings()
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            view.layer.addSublayer(previewLayer)
            previewLayer.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: AppDimensions.screenWidth, height: AppDimensions.screenHeight)
            previewLayer.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: AppDimensions.screenWidth, height: AppDimensions.screenHeight)
            //self.view.bringSubviewToFront(self.suggestionView)
            captureSession.startRunning()
            //           let dataOutput = AVCaptureVideoDataOutput()
            //           dataOutput.videoSettings = [
            //               ((kCVPixelBufferPixelFormatTypeKey as NSString) as String): NSNumber(value: kCVPixelFormatType_32BGRA)
            //           ]
            //           dataOutput.alwaysDiscardsLateVideoFrames = true
            //           if captureSession.canAddOutput(dataOutput) {
            //               captureSession.addOutput(dataOutput)
            //           }
            //           captureSession.commitConfiguration()
            //           let queue = DispatchQueue(label: "captureQueue")
            //           dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
        
        func presentCameraSettings() {
            let alertController = UIAlertController(title: "", message: "cameraAccessDenied", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "cancel", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(UIAlertAction(title: "settings", style: .cancel) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                            self.prepareCamera()
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            })
            self.present(alertController, animated: true)
        }
        
    }

     
