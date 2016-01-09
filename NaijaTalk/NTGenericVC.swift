//
//  GenericVC.swift
//  Groceries
//
//  Created by Johnson Ejezie on 04/01/2016.
//  Copyright © 2016 Johnson Ejezie. All rights reserved.
//

import Foundation
import UIKit

class NTGenericVC: UIViewController {
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenBackgroundIsTapped(){
        let tgr = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        self.view.addGestureRecognizer(tgr)
    }
}