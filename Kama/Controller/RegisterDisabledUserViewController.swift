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
    //When dUserName editing begins
    @IBAction func dPasswordEditingDidBegin(_ sender: TweeAttributedTextField)
    {
        
    }
    
    //While editing
    @IBAction func dPasswordEditingChanged(_ sender: TweeAttributedTextField)
    {
        if let userInput = sender.text
        {
            if userInput.count == 0
            {
                sender.activeLineColor = .blue
                sender.hideInfo(animated: true)
            }
            else if userInput.count < 3
            {
                sender.activeLineColor = .red
                sender.infoTextColor = .red
                sender.showInfo("3글자 이상 입력하세요", animated: true)
            }
            else
            {
                sender.activeLineColor = .green
                sender.infoTextColor = .green
                sender.showInfo("올바른 형식입니다", animated: true)
            }
        }
    }
    
    //When editing ended
    @IBAction func dPasswordEditingDidEnd(_ sender: TweeAttributedTextField)
    {
        
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

extension String
{
    var isValidEmail: Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
}
