//
//  RegisterNonDisabledUserViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/09.
//

import UIKit
import TweeTextField

class RegisterNonDisabledUserViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var userNameTextField: TweeAttributedTextField!
    @IBOutlet var passwordTextField: TweeAttributedTextField!
    @IBOutlet var termsAndConditions: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboard()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        termsAndConditions.layer.borderColor = UIColor.black.cgColor
        termsAndConditions.layer.borderWidth = 1
        termsAndConditions.isEditable = false
        termsAndConditions.isSelectable = false
        termsAndConditions.layer.cornerRadius = 15
        view.backgroundColor = UIColor(red: 0.80, green: 0.95, blue: 0.96, alpha: 1.00)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
}
