//
//Copyright (c) 2014 Daniele Spagnolo
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//

import UIKit

class SOXPanRotateZoomImageView: UIImageView, UIGestureRecognizerDelegate {
 
    var previousLocation = CGPoint.zero
    
    override init(image: UIImage!) {
        super.init(image: image)
        self.initialSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    func initialSetup() {
        self.isUserInteractionEnabled = true
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        rotationRecognizer.delegate = self
        self.addGestureRecognizer(rotationRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action:  #selector(handlePan(_:)))
        panRecognizer.delegate = self
        self.addGestureRecognizer(panRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchRecognizer.delegate = self
        self.addGestureRecognizer(pinchRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
        previousLocation = self.center
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        gesture.view!.transform = gesture.view!.transform.rotated(by: gesture.rotation);
        gesture.rotation = 0;
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview!)
        let newPosition = CGPoint(x: previousLocation.x + translation.x, y: previousLocation.y + translation.y)
        self.center = newPosition
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        gesture.view!.transform = gesture.view!.transform.scaledBy(x: gesture.scale, y: gesture.scale);
        gesture.scale = 1;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
