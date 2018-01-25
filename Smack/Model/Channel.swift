//
//  Channel.swift
//  Smack
//
//  Created by Иван on 25.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import Foundation

struct Channel: Decodable {
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
}
