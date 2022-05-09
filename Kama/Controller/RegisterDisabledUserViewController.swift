//
//  RegisterDisabledUserViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/09.
//

import UIKit
import TweeTextField

class RegisterDisabledUserViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var dUserName: TweeAttributedTextField!
    @IBOutlet var dUserPassword: TweeAttributedTextField!
    @IBOutlet var dTermsAndConditions: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboard()
        dUserName.delegate = self
        dUserPassword.delegate = self
        dTermsAndConditions.layer.borderColor = UIColor.black.cgColor
        dTermsAndConditions.layer.borderWidth = 1
        dTermsAndConditions.isEditable = false
        dTermsAndConditions.isSelectable = false
        dTermsAndConditions.layer.cornerRadius = 15
        view.backgroundColor = UIColor(red: 0.57, green: 0.89, blue: 0.65, alpha: 1.00)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
}
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
