//
//  ViewController.swift
//  SlideUpView
//
//  Created by Sam Ding on 9/2/19.
//  Copyright © 2019 Kaishan Ding. All rights reserved.
//

/* MIT License
 
 Copyright (c) [year] [fullname]
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

//MARK: Edit your constant here
struct SlideViewConstant {
    static let slideViewHeight: CGFloat = 350
    static let cornerRadiusOfSlideView: CGFloat = 20
    static let animationTime: CGFloat = 0.3
    
}

class ViewController: UIViewController {

    @IBOutlet weak var slideUpView: SlideView!
    @IBOutlet weak var slideUpBtn: UIButton!
    
    let blackView = UIView()
    let animationTime = SlideViewConstant.animationTime
    var originalCenterOfslideUpView = CGFloat()
    var totalDistance = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView(){
        slideUpView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: SlideViewConstant.slideViewHeight)
        slideUpView.layoutIfNeeded()
        slideUpView.addDropShadow(cornerRadius: SlideViewConstant.cornerRadiusOfSlideView)
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.frame = self.view.frame
        blackView.frame.size.height = self.view.frame.height
        blackView.alpha = 0
        self.view.insertSubview(blackView, belowSubview: slideUpView)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        let downPan = UIPanGestureRecognizer(target: self, action: #selector(dismissslideUpView(_:)))
        slideUpView.addGestureRecognizer(downPan)
    }
    
    //Animation when user interacts with the slide view
    @objc func dismissslideUpView(_ gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.slideUpView)
        switch gestureRecognizer.state{
        case .began, .changed:
            //Pan gesture began and continued

            gestureRecognizer.view!.center = CGPoint(x: self.slideUpView.center.x, y: max(gestureRecognizer.view!.center.y + translation.y, originalCenterOfslideUpView))
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.slideUpView)
            totalDistance += translation.y
            break
        case .ended:
            //Pan gesture ended
            // Set a constant : self.slideUpView.center.y > self.view.bounds.height - 40
            // OR set the following if statement
            if gestureRecognizer.velocity(in: slideUpView).y > 300 {
                handleDismiss()
            } else if totalDistance >= 0{
                UIView.animate(withDuration: TimeInterval(animationTime), delay: 0, options: [.curveEaseOut],
                               animations: {
                                self.slideUpView.center.y -= self.totalDistance
                                self.slideUpView.layoutIfNeeded()
                }, completion: nil)
            } else {
                // Cate other exceptions
                
            }
            
            totalDistance = 0
            break
        case .failed:
            print("Failed to do UIPanGestureRecognizer with slideUpView")
            break
        default:
            //default
            print("default: UIPanGestureRecognizer")
            break
        }
        
    }
    
    @IBAction func slide(_ sender: Any) {
        totalDistance = 0
        slideUpView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: SlideViewConstant.slideViewHeight)
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            self.blackView.alpha = 1
            self.slideUpView.backgroundColor = UIColor.white
            self.slideUpView.layer.cornerRadius = SlideViewConstant.cornerRadiusOfSlideView
            self.slideUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.slideUpBtn.isHidden = true
        }, completion: nil)
        slideUpView.slideUpShow(animationTime)
        self.tabBarController?.tabBar.isHidden = true
        originalCenterOfslideUpView = slideUpView.center.y
        
        
    }
    @objc func handleDismiss() {
        UIView.animate(withDuration: TimeInterval(animationTime)) {
            self.blackView.alpha = 0
            self.slideUpView.layer.cornerRadius = 0
            self.slideUpView.backgroundColor = .clear
        }
        slideUpView.slideDownHide(animationTime)
        slideUpBtn.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
    }


}

extension UIView {
    
    // add drop shadow effect
    func addDropShadow(scale: Bool = true, cornerRadius: CGFloat ) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 1.5
        
        //layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    // animate UIView expand from bottom to top and vice versa
    
    func slideUpShow(_ duration: CGFloat){
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        //self.isHidden = false
    }
    func slideDownHide(_ duration: CGFloat){
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            //self.isHidden = true
        })
    }
    
    
    
    
}

