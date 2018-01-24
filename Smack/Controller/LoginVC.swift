//
//  LoginVC.swift
//  Smack
//
//  Created by Иван Соколовский on 23.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    // Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
