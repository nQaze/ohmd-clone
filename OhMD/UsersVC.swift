//
//  UsersVC.swift
//  OhMD
//
//  Created by Nabil Kazi on 09/01/21.
//  Copyright © 2021 Nabil Kazi. All rights reserved.
//

import UIKit
import CometChatPro

class UsersVC: UIViewController {
    
    static func storyboardInstance() -> UsersVC? {
        let storyboard = UIStoryboard(name: "Main" ,bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "UsersVC") as? UsersVC
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPatientButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var users = [User]()
    var userRequest = UsersRequest.UsersRequestBuilder(limit: 20).friendsOnly(true).build()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        fetchUsers()
        
        if appDelegate.userType == .patient{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func registerTableViewCells(){
        let userView  = UINib.init(nibName: "CometChatUserView", bundle: nil)
        self.tableView.register(userView, forCellReuseIdentifier: "userView")
    }

    private func fetchUsers() {
        userRequest = UsersRequest.UsersRequestBuilder(limit: 20).friendsOnly(true).build()
        userRequest.fetchNext(onSuccess: { (users) in
            print("fetchUsers onSuccess: \(users)")
            if users.count != 0 {
                self.users.append(contentsOf: users)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }) { (error) in
            print("fetchUsers error:\(String(describing: error?.errorDescription))")
        }
    }
    
    private func lauchCCMessageListWithUser(_ user: User) {
        let messageList = CometChatMessageList()
        messageList.set(conversationWith: user, type: .user)
        self.navigationController?.pushViewController(messageList, animated: true)
    }
    
}

extension UsersVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userView", for:  indexPath) as! CometChatUserView
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.lauchCCMessageListWithUser(user)
    }
}
