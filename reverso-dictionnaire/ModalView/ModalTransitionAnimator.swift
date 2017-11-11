//
//  ModalTransitionAnimator.swift
//  reverso-dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class ModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var type: ModalTransitionAnimatorType
    
    init(type:ModalTransitionAnimatorType) {
        self.type = type
    }
    
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            
            from!.view.frame.origin.y = 800
            
            print("animating...")
            
        }) { (completed) -> Void in
            print("animate completed")
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}

internal enum ModalTransitionAnimatorType {
    case Present
    case Dismiss
}

