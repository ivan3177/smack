//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Иван Соколовский on 23.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeTapped(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
