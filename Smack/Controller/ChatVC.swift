//
//  ChatVC.swift
//  Smack
//
//  Created by Иван Соколовский on 23.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var sendMsgBtn: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    private var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        messagesTableView.estimatedRowHeight = 80
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        sendMsgBtn.isHidden = true
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController
            .revealToggle(_:)), for: .touchUpInside)
        menuBtn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)),
                                               name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)),
                                               name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.getMessage { (success) in
            if success {
                self.messagesTableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1,
                                             section: 0)
                    self.messagesTableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channelId == channel {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUsersLbl.text = "\(names) \(verb) typing a messge"
            } else {
                self.typingUsersLbl.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log in"
            messagesTableView.reloadData()
        }
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessages(forChannel: channelId) { (success) in
            if success {
                self.messagesTableView.reloadData()
            }
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxt.text, messageTxt.text != "" else { return }
            
            SocketService.instance.sendMessage(message: message, userId: UserDataService
                .instance.id, channelId: channelId) { (success) in
                    if success {
                        self.messageTxt.text = ""
                        self.messageTxt.resignFirstResponder()
                        SocketService.instance.manager.defaultSocket.emit(SOCKET_EVT_START_TYPE,
                                                                          UserDataService.instance
                                                                            .name, channelId)
                    }
            }
        }
    }
    
    @IBAction func messageTxtEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        if messageTxt.text == "" {
            isTyping = false
            sendMsgBtn.isHidden = true
            SocketService.instance.manager.defaultSocket.emit(SOCKET_EVT_STOP_TYPE, UserDataService
                .instance.name, channelId)
        } else {
            if isTyping == false {
                sendMsgBtn.isHidden = false
                SocketService.instance.manager.defaultSocket.emit(SOCKET_EVT_START_TYPE,
                                                                  UserDataService.instance.name,
                                                                  channelId)
            }
            isTyping = true
        }
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        if let cell = messagesTableView.dequeueReusableCell(withIdentifier: "messageCell", for:
            indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return MessageCell()
        }
    }

}
