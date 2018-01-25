//
//  AddChannelVC.swift
//  Smack
//
//  Created by Иван on 25.01.2018.
//  Copyright © 2018 iSOKOL DEV. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    // Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        spinner.isHidden = true
        nameTxt.attributedPlaceholder = NSAttributedString(string: "channel name", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
        descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        bgView.addGestureRecognizer(closeTap)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        spinner.startAnimating()
        spinner.isHidden = false
        
        guard let name = nameTxt.text, nameTxt.text != "" else { return }
        guard let description = descriptionTxt.text else { return }
        SocketService.instance.addChannel(channelName: name, channelDescription: description) { (success) in
            if success {
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
