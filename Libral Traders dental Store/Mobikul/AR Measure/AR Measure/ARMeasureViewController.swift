//
/**
ARRulerNew
@Category Webkul
@author Webkul <support@webkul.com>
FileName: ViewController.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license   https://store.webkul.com/license.html
*/

import UIKit
import ARKit
import SceneKit

class ARMeasureViewController: UIViewController {



private var line: LineNode?
private var lineSet: LineSetNode?


private var lines: [LineNode] = []
private var lineSets: [LineSetNode] = []
private var planes = [ARPlaneAnchor: Plane]()
private var focusSquare: FocusSquare?
private let indicator = UIImageView()
private let sceneView: ARSCNView =  ARSCNView(frame: UIScreen.main.bounds)
private let placeButton = UIButton(size: CGSize(width: 80, height: 80), image: #imageLiteral(resourceName: "place_area"))
private let cancleButton = UIButton(size: CGSize(width: 60, height: 60), image: #imageLiteral(resourceName: "cancle_delete"))
private let finishButton = UIButton(size: CGSize(width: 60, height: 60), image: #imageLiteral(resourceName: "place_done"))
var valueClosure:((String)->Void)?
    
private let resultLabel = UILabel().then({
    $0.textAlignment = .center
    $0.textColor = UIColor.black
    $0.numberOfLines = 0
    $0.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.heavy)
})
    
enum MeasurementMode {
    case length
    case area
    func toAttrStr() -> NSAttributedString {
        return NSAttributedString(string: "Start", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
                                                                NSAttributedString.Key.foregroundColor: UIColor.black])
    }
}
typealias Localization = R.string.rulerString
private var mode = MeasurementMode.length
    
private var measureUnit = ApplicationSetting.Status.defaultUnit {
    didSet {
        let v = measureValue
        measureValue = v
    }
}
private var measureValue: MeasurementUnit? {
    didSet {
        if let m = measureValue {
            resultLabel.text = nil
            resultLabel.attributedText = m.attributeString(type: measureUnit)
        } else {
            resultLabel.attributedText = mode.toAttrStr()
        }
    }
}
var resultValue:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViewController()
        setupFocusSquare()
        sceneView.delegate = self
    }
    
    
    
    private func layoutViewController() {
    
        let width = view.bounds.width
        let height = view.bounds.height
        view.backgroundColor = UIColor.black
        
        do {
            view.addSubview(sceneView)
            sceneView.frame = view.bounds
            sceneView.delegate = self
        }
        
        do {
            let resultLabelBg = UIView()
            resultLabelBg.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            resultLabelBg.layer.cornerRadius = 45
            resultLabelBg.clipsToBounds = true
            

            let copy = UIButton(size: CGSize(width: 30, height: 30), image: #imageLiteral(resourceName: "result_copy"))
            copy.addTarget(self, action: #selector(ARMeasureViewController.copyAction(_:)), for: .touchUpInside)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ARMeasureViewController.changeMeasureUnitAction(_:)))
            resultLabel.addGestureRecognizer(tap)
            resultLabel.isUserInteractionEnabled = true
            
            
            resultLabelBg.frame = CGRect(x: 30, y: 30, width: width - 60, height: 90)
            copy.frame = CGRect(x: resultLabelBg.frame.maxX - 10 - 30,
                                y: resultLabelBg.frame.minY + (resultLabelBg.frame.height - 30)/2,
                                width: 30, height: 30)
            resultLabel.frame = resultLabelBg.frame.insetBy(dx: 10, dy: 0)
            resultLabel.attributedText = mode.toAttrStr()
            
            view.addSubview(resultLabelBg)
            view.addSubview(resultLabel)
            view.addSubview(copy)
            
            
            
        }
        
        
        do {
            indicator.image = #imageLiteral(resourceName: "img_indicator_disable")
            view.addSubview(indicator)
            indicator.frame = CGRect(x: (width - 60)/2, y: (height - 60)/2, width: 60, height: 60)
        }
        do {
        view.addSubview(placeButton)
        placeButton.addTarget(self, action: #selector(ARMeasureViewController.placeAction(_:)), for: .touchUpInside)
        placeButton.frame = CGRect(x: (width - 80)/2, y: (height - 20 - 80), width: 80, height: 80)
        }
        do {
            view.addSubview(cancleButton)
            cancleButton.addTarget(self, action: #selector(ARMeasureViewController.deleteAction(_:)), for: .touchUpInside)
            cancleButton.frame = CGRect(x: 40, y: placeButton.frame.origin.y + 10, width: 60, height: 60)
        }
        
        do{
            view.addSubview(finishButton)
            finishButton.addTarget(self, action: #selector(ARMeasureViewController.finishMesure(_:)), for: .touchUpInside)
            finishButton.frame = CGRect(x: (width - 40 - 60), y: placeButton.frame.origin.y + 10, width: 60, height: 60)
        }
        
    
    }
    
    
    @objc func changeMeasureUnitAction(_ sender: UITapGestureRecognizer) {
        measureUnit = measureUnit.next()
    }
    
    @objc func copyAction(_ sender: UIButton) {
        UIPasteboard.general.string = resultLabel.text
        HUG.show(title: "Has been copied to the scrapbook")
    }
    
    @objc func deleteAction(_ sender: UIButton) {
            if line != nil {
                line?.removeFromParent()
                line = nil
            } else if let lineLast = lines.popLast() {
                lineLast.removeFromParent()
            } else {
                lineSets.popLast()?.removeFromParent()
            }
        measureValue = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func finishMesure(_ sender: UIButton) {
        if let result = measureValue?.originalValue(type: measureUnit){
            print("sss", result)
            self.dismiss(animated: true, completion: nil)
            valueClosure?(result)
        }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.restartSceneView()
    }

    func restartSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        measureUnit = ApplicationSetting.Status.defaultUnit
        resultLabel.attributedText = mode.toAttrStr()
        resultValue = ""
        updateFocusSquare()
    }
    
    func updateLine() -> Void {
        let startPos = sceneView.worldPositionFromScreenPosition(self.indicator.center, objectPos: nil)
        if let p = startPos.position {
            let camera = self.sceneView.session.currentFrame?.camera
            let cameraPos = SCNVector3.positionFromTransform(camera!.transform)
            if cameraPos.distanceFromPos(pos: p) < 0.05 {
                if line == nil {
                    indicator.image = #imageLiteral(resourceName: "img_indicator_disable")
                }
                return;
            }
            indicator.image = #imageLiteral(resourceName: "img_indicator_enable")
            guard let currentLine = line else {
                    return
                }
                let length = currentLine.updatePosition(pos: p, camera: self.sceneView.session.currentFrame?.camera, unit: measureUnit)
                measureValue =  MeasurementUnit(meterUnitValue: length, isArea: false)
    
        }
    }
    
    
    
    
    
    @objc func placeAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction,.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (value) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction,.curveEaseIn], animations: {
                sender.transform = CGAffineTransform.identity
            }) { (value) in
            }
        }
        if let l = line {
            lines.append(l)
            line = nil
        } else  {
            let startPos = sceneView.worldPositionFromScreenPosition(indicator.center, objectPos: nil)
            if let p = startPos.position {
                line = LineNode(startPos: p, sceneV: sceneView)
            }
        }

    }


}




extension ARMeasureViewController: ARSCNViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        DispatchQueue.main.async {
            HUG.show(title: (error as NSError).localizedDescription)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFocusSquare()
            self.updateLine()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.addPlane(node: node, anchor: planeAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(anchor: planeAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.removePlane(anchor: planeAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //5
        switch camera.trackingState {
        case ARCamera.TrackingState.notAvailable:
            indicator.image = #imageLiteral(resourceName: "img_indicator_disable")
        case ARCamera.TrackingState.limited(_):
            indicator.image = #imageLiteral(resourceName: "img_indicator_disable")
        case ARCamera.TrackingState.normal:
            indicator.image = #imageLiteral(resourceName: "img_indicator_enable")
        }
        
        
    }
    
   
}



fileprivate extension ARMeasureViewController {
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        
        let plane = Plane(anchor, false)
        planes[anchor] = plane
        node.addChildNode(plane)
        indicator.image = #imageLiteral(resourceName: "img_indicator_enable")
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
    func removePlane(anchor: ARPlaneAnchor) {
        if let plane = planes.removeValue(forKey: anchor) {
            plane.removeFromParentNode()
        }
    }
}


fileprivate extension ARMeasureViewController {
    
    func setupFocusSquare() {
        focusSquare?.isHidden = true
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
    }
    
    func updateFocusSquare() {
        if ApplicationSetting.Status.displayFocus {
            focusSquare?.unhide()
        } else {
            focusSquare?.hide()
        }
        let (worldPos, planeAnchor, _) = sceneView.worldPositionFromScreenPosition(sceneView.bounds.mid, objectPos: focusSquare?.position)
        if let worldPos = worldPos {
            focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: sceneView.session.currentFrame?.camera)
        }
    }
}







