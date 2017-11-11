//
//  ModalNavigationController.swift
//  reverso-dictionnaire
//
//  Created by eleves on 2017-11-08.
//  Copyright © 2017 com.henrique. All rights reserved.
//

import UIKit

class ModalNavigationController: UINavigationController, ModalPresentable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isModalMaximized() ? .default : .lightContent
    }
    
}

