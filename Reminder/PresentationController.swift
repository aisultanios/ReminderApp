//
//  PresentationController.swift
//  Reminder
//
//  Created by Aisultan Askarov on 31.10.2022.
//

import UIKit

class PresentationController: UIPresentationController {

    let blurView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.translatesAutoresizingMaskIntoConstraints = false
                
        return view
    }()
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    var emptySpace: CGFloat = 0.35
    var viewControllersSpace: CGFloat = 0.65
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.blurView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * emptySpace), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * viewControllersSpace))
    }
    
    override func presentationTransitionWillBegin() {
        self.blurView.alpha = 0
        self.containerView?.addSubview(blurView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurView.alpha = 1.0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView!.roundCorners([.topLeft, .topRight], radius: 15)
        presentedView!.layer.masksToBounds = false
        presentedView!.layer.shadowColor = UIColor.black.cgColor
        presentedView!.layer.shadowOpacity = 0.65
        presentedView!.layer.shadowRadius = 20
        presentedView!.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurView.frame = containerView!.bounds
    }

    @objc func dismissController(){
        
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
  }

  extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
  }
