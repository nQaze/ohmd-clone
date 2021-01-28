//
//  LoginVC.swift
//  OhMD
//
//  Created by Nabil Kazi on 21/12/20.
//  Copyright © 2020 Nabil Kazi. All rights reserved.
//

import UIKit
import CometChatPro
import Firebase

class LoginVC: BaseVC {
    
    static func storyboardInstance() -> LoginVC? {
        let storyboard = UIStoryboard(name: "Main" ,bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
    }
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var userType: UserType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    @IBAction func openSignUpPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationVC: RegistrationVC = storyboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        registrationVC.userType = userType
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        loginUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    private func loginUser(email: String, password: String){
        showActivityIndicator()
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.hideActivityIndicator()
            if let error = error as NSError? {
              switch AuthErrorCode(rawValue: error.code) {
              case .userDisabled:
                    print("Error: \(error.localizedDescription)")
              case .wrongPassword:
                    print("Error: \(error.localizedDescription)")
              case .invalidEmail:
                    print("Error: \(error.localizedDescription)")
              default:
                    print("Error: \(error.localizedDescription)")
              }
            } else {
                print("FA User signs in successfully")
                if let user = Auth.auth().currentUser{
                    let uid = user.uid
                    self.loginUser(uid: uid)
                }
            }
        }
    }
    
    private func loginUser(uid: String){
        showActivityIndicator()
        CometChat.login(UID: uid, apiKey: Constants.authKey, onSuccess: { (user) in
            print("CC Login successful : " + user.stringValue())
            self.hideActivityIndicator()
            self.openHomeVC()
        }) { (error) in
            print("CC Login failed with error: " + error.errorDescription);
            self.hideActivityIndicator()
        }
    }
    
    private func openHomeVC(){
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeNavVC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController
            UIApplication.shared.windows.first?.rootViewController = homeNavVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    private func showActivityIndicator(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

}
