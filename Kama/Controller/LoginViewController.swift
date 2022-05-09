//
//  LoginViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/09.
//

import UIKit
import TweeTextField

class LoginViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var loginView: UIView!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var passwordLoginTextField: TweeAttributedTextField!
    @IBOutlet var nameLoginTextField: TweeAttributedTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboard()
        nameLoginTextField.delegate = self
        passwordLoginTextField.delegate = self
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.black.cgColor
        loginView.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 26
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
}
