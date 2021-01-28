//
//  AddPatientVC.swift
//  OhMD
//
//  Created by Nabil Kazi on 03/01/21.
//  Copyright © 2021 Nabil Kazi. All rights reserved.
//

import UIKit
import CometChatPro
import Firebase
import MessageUI

class AddPatientVC: BaseVC, MFMessageComposeViewControllerDelegate {
    
    static func storyboardInstance() -> AddPatientVC? {
        let storyboard = UIStoryboard(name: "Main" ,bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddPatientVC") as? AddPatientVC
    }

    @IBOutlet weak var addPatientButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundView: UIView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var secondaryAuth: Auth?
    var db: Firestore?
    var referralCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getLoggedInDoctorObj()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    private func getLoggedInDoctorObj(){
        let docRef = db?.collection("doctors").document(Auth.auth().currentUser!.uid)
        docRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                self.referralCode = document.get("referral_code") as? String
                print("Document data: \(self.referralCode ?? "")")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func addPatientPressed(_ sender: Any) {
        let user = UserModel(id: "",
                             name: nameTextField.text!,
                             email: emailTextField.text!,
                             mobile: mobileTextField.text!,
                             password: "",
                             code: referralCode)
        savePatientInFirestore(patient: user)
    }
    
    private func savePatientInFirestore(patient: UserModel){
        showActivityIndicator()
        
        db?.collection("patients").document(patient.mobile!).setData([
            "id": "",
            "name": patient.name!,
            "mobile": patient.mobile!,
            "email": patient.email!,
            "invite_code": patient.code!
        ]) { err in
            self.hideActivityIndicator()
            if let err = err {
                print("Error adding patient in Firestore: \(err)")
            } else {
                print("Patient added in Firestore")
                DispatchQueue.main.async {
                    self.displayMessageInterfaceForPatient(patient)
                }
            }
        }
    }
    
    private func goBack(){
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
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
    
    func displayMessageInterfaceForPatient(_ patient: UserModel) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [patient.mobile!]
        composeVC.body = "Hi \(patient.name!), you are invited to OhMD to chat with your Doctor. Your invite code is \(patient.code!)."
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        self.dismiss(animated: true){
            self.goBack()
        }
//        switch (result.rawValue) {
//            case MessageComposeResult.cancelled.rawValue:
//            print("Message was cancelled")
//            self.dismiss(animated: true, completion: nil)
//        case MessageComposeResult.failed.rawValue:
//            print("Message failed")
//            self.dismiss(animated: true, completion: nil)
//        case MessageComposeResult.sent.rawValue:
//            print("Message was sent")
//            self.dismiss(animated: true, completion: nil)
//        default:
//            break;
//        }
        
    }
}
