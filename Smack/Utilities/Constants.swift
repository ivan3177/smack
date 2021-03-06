//
//  Constants.swift
//  Smack
//
//  Created by Иван Соколовский on 23.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let BASE_URL = "http://isokol-dev.ru:3005/v1"
let URL_REGISTER = "\(BASE_URL)/account/register"
let URL_LOGIN = "\(BASE_URL)/account/login"
let URL_CREATE_USER = "\(BASE_URL)/user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)/user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)/channel"
let URL_GET_MESSAGES = "\(BASE_URL)/message/byChannel/"

// Socket events
let SOCKET_EVT_NEW_CHANNEL = "newChannel"
let SOCKET_EVT_CHANNEL_CREATED = "channelCreated"
let SOCKET_EVT_NEW_MESSAGE = "newMessage"
let SOCKET_EVT_MESSAGE_CREATED = "messageCreated"
let SOCKET_EVT_USER_TYPING_UPDATE = "userTypingUpdate"
let SOCKET_EVT_START_TYPE = "startType"
let SOCKET_EVT_STOP_TYPE = "stopType"

// Colors
let SMACK_PURPLE_PLACEHOLDER = #colorLiteral(red: 0.2395215631, green: 0.3320434093, blue: 0.7513638139, alpha: 0.5)

// Notifications
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("notifChannelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("notifChannelSelected")

// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// User Defauls
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Header
let HEADER = [
    "ContentType": "application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "ContentType": "application/json; charset=utf-8"
]
