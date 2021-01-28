//
//  RegistrationVC.swift
//  OhMD
//
//  Created by Nabil Kazi on 21/12/20.
//  Copyright © 2020 Nabil Kazi. All rights reserved.
//

import UIKit
import CometChatPro
import Firebase
import Alamofire

class RegistrationVC: BaseVC {
    
    static func storyboardInstance() -> RegistrationVC? {
        let storyboard = UIStoryboard(name: "Main" ,bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC
    }
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var inviteCodeTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var inviteCodeView: UIView!
    
    var db: Firestore?
    var userType: UserType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        if userType == .doctor{
            inviteCodeView.isHidden = true
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if userType == .doctor{
            registerUser()
        }else{
            fetchPatientByMobile(mobileTextField.text!)
        }
    }
    
    @IBAction func openSignInPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchPatientByMobile( _ mobile : String){
        showActivityIndicator()
        db?.collection("patients").whereField("mobile", isEqualTo: mobile)
            .getDocuments() { (querySnapshot, err) in
                self.hideActivityIndicator()
                if let err = err {
                    print("Error getting patient: \(err)")
                } else {
                    print("Success getting patient")
                    if let patient = querySnapshot!.documents.first{
                        let inviteCode = patient.get("invite_code") as? String
                        if inviteCode == self.inviteCodeTextField.text {
                            self.registerUser()
                        }
                    }
                }
        }
    }
    
    private func registerUser(){
        
        var user = UserModel(id: "",
                             name: nameTextField.text!,
                             email: emailTextField.text!,
                             mobile: mobileTextField.text!,
                             password: passwordTextField.text!,
                             code: inviteCodeTextField.text ?? "")
        
        showActivityIndicator()

        Auth.auth().createUser(withEmail: user.email!, password: user.password!) { authResult, error in
            self.hideActivityIndicator()
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                    case .emailAlreadyInUse:
                    print("Error: \(error.localizedDescription)")
                    case .invalidEmail:
                    print("Error: \(error.localizedDescription)")
                    case .weakPassword:
                    print("Error: \(error.localizedDescription)")
                    default:
                    print("Error: \(error.localizedDescription)")
                }
          } else {
                print("User signs up successfully")
                if let authUser = Auth.auth().currentUser{
                    user.id = authUser.uid
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = user.name!
                    changeRequest?.commitChanges { (error) in
                        if let error = error as NSError? {
                            print("Error: \(error.localizedDescription)")
                        }else{
                            print("Details updated successfully")
                            if self.userType == .doctor{
                                self.saveDoctorInFirestore(doctor: user)
                            }else{
                                self.updatePatientInFirestore(patient: user)
                            }
                        }
                    }
                }
          }
        }
    }
    
    private func saveDoctorInFirestore(doctor: UserModel){
        showActivityIndicator()
        db?.collection("doctors").document(doctor.id!).setData([
            "id": doctor.id!,
            "name": doctor.name!,
            "mobile": doctor.mobile!,
            "email": doctor.email!,
            "referral_code": randomString(length: 5)
        ]) { err in
            self.hideActivityIndicator()
            if let err = err {
                print("Error adding doctor in Firestore: \(err)")
            } else {
                print("Doctor added in Firestore")
                self.registerCometChatUser(doctor)
            }
        }
    }
    
    private func updatePatientInFirestore(patient: UserModel){
        showActivityIndicator()
        db?.collection("patients").document(patient.mobile!).updateData([
            "id": patient.id!
        ]) { err in
            self.hideActivityIndicator()
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.registerCometChatUser(patient)
            }
        }
    }
    
    private func registerCometChatUser(_ user: UserModel){
        showActivityIndicator()
        let newUser : CometChatPro.User = User(uid: user.id!, name: user.name!)
        CometChat.createUser(user: newUser, apiKey: Constants.authKey, onSuccess: { (User) in
            print("User created successfully. \(User.stringValue())")
            self.hideActivityIndicator()
            if CometChat.getLoggedInUser() == nil {
                self.loginUser(user)
            }
          }) { (error) in
            print("The error is \(String(describing: error?.errorDescription))")
            self.hideActivityIndicator()
        }
    }
    
    private func loginUser(_ user: UserModel){
        showActivityIndicator()
        CometChat.login(UID: user.id!, apiKey: Constants.authKey, onSuccess: { (ccUser) in
            print("Login successful : " + ccUser.stringValue())
            self.hideActivityIndicator()
            if self.userType == .doctor{
                self.openHomeVC()
            }else{
                self.fetchDoctorByReferralCode(user.code!)
            }
        }) { (error) in
            print("Login failed with error: " + error.errorDescription);
            self.hideActivityIndicator()
        }
    }
    
    
    private func fetchDoctorByReferralCode( _ referralCode : String){
        showActivityIndicator()
        db?.collection("doctors").whereField("referral_code", isEqualTo: referralCode)
            .getDocuments() { (querySnapshot, err) in
                self.hideActivityIndicator()
                if let err = err {
                    print("Error getting patient: \(err)")
                } else {
                    print("Success getting patient")
                    if let doctor = querySnapshot!.documents.first{
                        let id = doctor.get("id") as? String
                        self.updateFriendInCometChat(uid: id!)
                    }
                }
        }
    }
    
    private func updateFriendInCometChat(uid: String){
        showActivityIndicator()
        
        let headers: HTTPHeaders = [
            "appId": Constants.appId,
            "apiKey": Constants.apiKey,
            "Accept": "application/json"
        ]
        
        let parameters: [String: [String]] = [
            "accepted": [uid]
        ]
        
        let uid = Auth.auth().currentUser?.uid
        AF.request("https://api-us.cometchat.io/v2.0/users/\(uid!)/friends",
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers).responseJSON { response in
            
            self.hideActivityIndicator()
                
            debugPrint(response)
            if response.error == nil{
                self.openHomeVC()
            }
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

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
