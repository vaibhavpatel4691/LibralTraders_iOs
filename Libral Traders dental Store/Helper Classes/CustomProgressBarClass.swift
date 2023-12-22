//
//  CustomProgressBarClass.swift
//  Libral Traders
//
//  Created by Invention Hill on 29/09/23.
//

import Foundation
import UIKit

class CustomProgressBarView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let progressHeight = rect.height * CGFloat(progress)
        let progressBarRect = CGRect(x: 0, y: 0, width: rect.width, height: progressHeight)
        
        let progressColor = UIColor.green // Set your desired progress color
        
        progressColor.setFill()
        UIRectFillUsingBlendMode(progressBarRect, .sourceIn)
    }
    
    
    // Add a property to keep track of the progress
    var progress: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    func animateProgress(to endValue: Float, duration: TimeInterval) {
//        UIView.animate(withDuration: duration, animations: {
//            self.progress = endValue
//            print("Progress value:---------",endValue)
//        })
//    }
    
   /* func animateProgress(to endValue: Float, duration: TimeInterval) {
            let numberOfSteps = 60
            
            let stepValue = endValue / Float(numberOfSteps)
            
            var currentStep = 0
            
            Timer.scheduledTimer(withTimeInterval: duration , repeats: true) { timer in
                currentStep += 1
                self.progress += stepValue
                
                if currentStep == numberOfSteps {
                    timer.invalidate()
                    self.progress = endValue
                }
            }
        }*/
    func animateProgress(to endValue: Float, duration: TimeInterval) {
            let steps = 1000 // Number of steps for the animation
            let stepValue = endValue / Float(steps)
            
            func animateStep(currentStep: Int) {
                if currentStep >= steps {
                    self.progress = endValue
                } else {
                    let newValue = Float(currentStep) * stepValue
                    UIView.animate(withDuration: duration/Double(steps), animations: {
                        self.progress = newValue
                    }) { _ in
                        animateStep(currentStep: currentStep + 1)
                    }
                }
            }
            
            animateStep(currentStep: 0)
        }
    
}
