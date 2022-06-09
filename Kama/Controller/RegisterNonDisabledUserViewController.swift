//
//  RegisterNonDisabledUserViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/09.
//

import UIKit
import TweeTextField
import FirebaseFirestore

class RegisterNonDisabledUserViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet var ContentView: UIView!
    @IBOutlet var userNameTextField: TweeAttributedTextField!
    @IBOutlet var passwordTextField: TweeAttributedTextField!
    @IBOutlet var termsAndConditions: UITextView!
    
    let db = Firestore.firestore()
    
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
        ContentView.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.92, alpha: 1.00)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    @IBAction func NDUserSignUp(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "I accept and agree to the Terms of Agreement", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default)
        { [self] (action) in
            let ref = self.db.collection("userDB").document()
            ref.setData(["userName":self.userNameTextField.text!, "password": self.passwordTextField.text!, "disabled": false, "id": UUID().uuidString, "point":0])
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
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Alert dismissed")
        }))
        present(alert, animated: true, completion: nil)
    }
}
