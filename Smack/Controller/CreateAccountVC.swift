//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Иван Соколовский on 23.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    // Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let pass = passwordTxt.text, passwordTxt.text != "" else { return }
        guard let name = usernameTxt.text, usernameTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func pickAvatarTapped(_ sender: Any) {
    }
    
    @IBAction func pickBGColorTapped(_ sender: Any) {
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }

}
