//
//  SocketService.swift
//  Smack
//
//  Created by Иван on 25.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    private override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    func addChannel(channelName name: String, channelDescription description: String,
                    completion: @escaping CompletionHandler) {
        manager.defaultSocket.emit(SOCKET_EVT_NEW_CHANNEL, name, description)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        manager.defaultSocket.on(SOCKET_EVT_CHANNEL_CREATED) { (dataArray, ack) in
            guard let name = dataArray[0] as? String else { return }
            guard let description = dataArray[1] as? String else { return }
            guard let id = dataArray[2] as? String else { return }
    
            let newChannel = Channel(channelTitle: name, channelDescription: description, id: id)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func sendMessage(message: String, userId: String, channelId: String, completion:
        @escaping CompletionHandler) {
        let user = UserDataService.instance
        manager.defaultSocket.emit(SOCKET_EVT_NEW_MESSAGE, message, userId, channelId, user.name,
                                   user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getMessage(completion: @escaping CompletionHandler) {
        manager.defaultSocket.on(SOCKET_EVT_MESSAGE_CREATED) { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            if channelId == MessageService.instance.selectedChannel?.id && AuthService
                .instance.isLoggedIn {
                let newMessage = Message(message: messageBody, userName: userName, channelId:
                    channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id,
                               timestamp: timeStamp)
                MessageService.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        manager.defaultSocket.on(SOCKET_EVT_USER_TYPING_UPDATE) { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }
    
}
