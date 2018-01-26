//
//  MessageService.swift
//  Smack
//
//  Created by Иван on 25.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    private init() {}
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel: Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding:
            JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                if let json = JSON(data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let desc = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: desc, id: id)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func fundAllMessages(forChannel channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding:
            JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                if let json = JSON(data).array {
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId:
                            channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor,
                                       id: id, timestamp: timeStamp)
                        self.messages.append(message)
                    }
                    completion(true)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}
