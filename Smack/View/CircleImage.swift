//
//  CircleImage.swift
//  Smack
//
//  Created by Иван Соколовский on 24.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
