//
//  ViewController.swift
//  SlideUpView
//
//  Created by Sam Ding on 9/2/19.
//  Copyright © 2019 Kaishan Ding. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slideUpView: UIView!
    @IBOutlet weak var slideUpBtn: UIButton!
    
    let blackView = UIView()
    let animationTime = CGFloat(0.3)
    var originalCenterOfslideUpView = CGFloat()
    var totalDistance = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView(){
        slideUpView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 350)
        slideUpView.layoutIfNeeded()
        slideUpView.addDropShadow(cornerRadius: 40)
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.frame = self.view.frame
        blackView.frame.size.height = self.view.frame.height
        blackView.alpha = 0
        self.view.insertSubview(blackView, belowSubview: slideUpView)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        let downPan = UIPanGestureRecognizer(target: self, action: #selector(dismissslideUpView(_:)))
        slideUpView.addGestureRecognizer(downPan)
    }
    
    //Animation when user interacts with the filter view
    @objc func dismissslideUpView(_ gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.slideUpView)
        switch gestureRecognizer.state{
        case .began, .changed:
            //Pan gesture began and continued
            //print(gestureRecognizer.view!.frame.origin.y + self.slideUpView.bounds.height)
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
    
    @IBAction func filter(_ sender: Any) {
        totalDistance = 0
        slideUpView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 350)
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            self.blackView.alpha = 1
            self.slideUpView.backgroundColor = UIColor.white
            self.slideUpView.layer.cornerRadius = 20
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

