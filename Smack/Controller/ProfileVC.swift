//
//  ProfileVC.swift
//  Smack
//
//  Created by Иван on 24.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    // Outlets
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        bgView.addGestureRecognizer(closeTap)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeModalTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
}
