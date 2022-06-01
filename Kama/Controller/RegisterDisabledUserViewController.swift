//
//  RegisterDisabledUserViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/09.
//

import UIKit
import TweeTextField
import FirebaseFirestore

class RegisterDisabledUserViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var ConteView: UIView!
    @IBOutlet var dUserName: TweeAttributedTextField!
    @IBOutlet var dUserPassword: TweeAttributedTextField!
    @IBOutlet var dTermsAndConditions: UITextView!
    
    let db = Firestore.firestore()
    
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
        ConteView.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.92, alpha: 1.00)
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
                sender.activeLineColor = .systemGreen
                sender.infoTextColor = .systemGreen
                sender.showInfo("올바른 형식입니다", animated: true)
            }
        }
    }
    
    //When editing ended
    @IBAction func dPasswordEditingDidEnd(_ sender: TweeAttributedTextField)
    {
        
    }
    
    @IBAction func DUserSignUp(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "회원가입 약관을 다 읽었으며 동의합니다", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "예", style: .default)
        { [self] (action) in
            let ref = self.db.collection("userDB").document()
            ref.setData(["userName":self.dUserName.text!, "password": self.dUserPassword.text!, "disabled": true, "id": UUID().uuidString, "point":0])
            { error in
            if let e = error
                {
                    print("There was an issue sending data to Firestore: \(e)")
                }
                else
                {
                    _ = navigationController?.popViewController(animated: true)
                    print("Successfully saved data.")
                }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Alert dismissed")
        }))
        present(alert, animated: true, completion: nil)
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
