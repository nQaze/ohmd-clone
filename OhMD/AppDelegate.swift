//
//  AppDelegate.swift
//  OhMD
//
//  Created by Nabil Kazi on 21/12/20.
//  Copyright © 2020 Nabil Kazi. All rights reserved.
//

import UIKit
import CometChatPro
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var db: Firestore?
    var userType: UserType?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initialiseCometChat()
        FirebaseApp.configure()
        db = Firestore.firestore()
        checkLogin()
        
        return true
    }
    
    private func checkLogin(){
        if isUserLoggedIn() {
            print("User is logged in")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeNavVC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController
            self.window?.rootViewController = homeNavVC
            self.window?.makeKeyAndVisible()
        }
    }
    
    private func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            CometChat.logout(onSuccess: {_ in }, onError: {_ in })
            openFirstVC()
        } catch {
            print("Sign out error")
        }
    }
    
//    func saveInUserDefaults(user: UserModel){
//        let defaults = UserDefaults.standard
//        defaults.set(user.id, forKey: "uid")
//        defaults.set(user.email, forKey: "email")
//        defaults.set(user.mobile, forKey: "mobile")
//        defaults.set(user.code, forKey: "code")
//        defaults.set(user.userType, forKey: "userType")
//    }
    
    private func openFirstVC(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let firstNavVC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavVC") as! UINavigationController
        self.window?.rootViewController = firstNavVC
        self.window?.makeKeyAndVisible()
    }
    
    private func initialiseCometChat(){
        let mySettings = AppSettings.AppSettingsBuilder().subscribePresenceForAllUsers().setRegion(region: Constants.region).build()
            
        CometChat(appId: Constants.appId ,appSettings: mySettings,onSuccess: { (isSuccess) in
            if (isSuccess) {
                print("CometChat Pro SDK intialise successfully.")
                CometChatCallManager().registerForCalls(application: self)
            }
        }) { (error) in
                print("CometChat Pro SDK failed intialise with error: \(error.errorDescription)")
        }
    }
}

extension UITableView {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.tableFooterView = UIView()
    }
}
