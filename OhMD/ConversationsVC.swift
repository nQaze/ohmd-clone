//
//  MyConversationsVC.swift
//  OhMD
//
//  Created by Nabil Kazi on 03/01/21.
//  Copyright © 2021 Nabil Kazi. All rights reserved.
//

import UIKit
import CometChatPro

class ConversationsVC: UIViewController {
    
    static func storyboardInstance() -> ConversationsVC? {
        let storyboard = UIStoryboard(name: "Main" ,bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ConversationsVC") as? ConversationsVC
    }

    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var conversations = [Conversation]()
    var conversationRequest = ConversationRequest.ConversationRequestBuilder(limit: 20)
        .setConversationType(conversationType: .user)
        .build()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchConversations()
    }

    private func registerTableViewCells(){
        let conversationView  = UINib.init(nibName: "CometChatConversationView", bundle: nil)
        self.tableView.register(conversationView, forCellReuseIdentifier: "conversationView")
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        print("Signout tapped")
        appDelegate.logoutUser()
    }
    
    private func fetchConversations() {
        conversationRequest = ConversationRequest.ConversationRequestBuilder(limit: 20)
        .setConversationType(conversationType: .user)
        .build()
        conversationRequest.fetchNext(onSuccess: { (conversationList) in
            print("success of convRequest \(conversationList)")
            self.conversations.removeAll()
            self.conversations.append(contentsOf: conversationList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (exception) in
            print("here exception \(String(describing: exception?.errorDescription))")
        }
    }
    
    private func lauchCCMessageListWithUser(_ user: User) {
        let messageList = CometChatMessageList()
        messageList.set(conversationWith: user, type: .user)
        self.navigationController?.pushViewController(messageList, animated: true)
    }
    
}

extension ConversationsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:    "conversationView", for: indexPath) as! CometChatConversationView
        let conversation = conversations[indexPath.row]
        cell.conversation = conversation
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = conversations[indexPath.row]
        self.lauchCCMessageListWithUser(conversation.conversationWith as! User)
    }
}
