//
//  ColorDetailsVC.swift
//  ColorApp
//
//  Created by Zehra Nur Açık on 19.11.2023.
//

import UIKit

class ColorDetailsVC: UIViewController {

    var color : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = color ?? .blue
    }
    

}
