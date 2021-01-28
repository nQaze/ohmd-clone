//
//  ViewController.swift
//  OhMD
//
//  Created by Nabil Kazi on 21/12/20.
//  Copyright © 2020 Nabil Kazi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    static func storyboardInstance() -> MainVC? {
        let storyboard = UIStoryboard(name: "Main" ,bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainVC
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func doctorTapped(_ sender: Any) {
        appDelegate.userType = .doctor
        openLoginVCForUserType(.doctor)
    }
    
    @IBAction func patientTapped(_ sender: Any) {
        appDelegate.userType = .patient
        openLoginVCForUserType(.patient)
    }
    
    private func openLoginVCForUserType(_ userType: UserType){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC: LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        loginVC.userType = userType
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

