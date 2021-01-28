//
//  HomeNavVC.swift
//  OhMD
//
//  Created by Nabil Kazi on 03/01/21.
//  Copyright © 2021 Nabil Kazi. All rights reserved.
//

import UIKit

class HomeNavVC: UINavigationController {
    
    static func storyboardInstance() -> HomeNavVC? {
        let storyboard = UIStoryboard(name: "Main" ,bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeNavVC") as? HomeNavVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
