//
//  PresentationController.swift
//  Reminder
//
//  Created by Aisultan Askarov on 31.10.2022.
//

import UIKit

class PresentationController: UIPresentationController {

    let blurViewController: UIView = {
       
        let visualEffectView = UIView()
        visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
                
        return visualEffectView
    }()
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

    var emptySpace: CGFloat = 0.6
    var viewControllersSpace: CGFloat = 0.4
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.blurViewController.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * emptySpace),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                                viewControllersSpace))
    }
    
    override func presentationTransitionWillBegin() {
        self.blurViewController.alpha = 0
        self.containerView?.addSubview(blurViewController)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurViewController.alpha = 1.0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurViewController.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurViewController.removeFromSuperview()
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
        blurViewController.frame = containerView!.bounds
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
