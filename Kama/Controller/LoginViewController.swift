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
        view.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.82, alpha: 1.00)
        nameLoginTextField.delegate = self
        passwordLoginTextField.delegate = self
        loginView.layer.borderWidth = 1
        loginView.layer.borderColor = UIColor.black.cgColor
        loginView.layer.cornerRadius = 20
        loginButton.layer.cornerRadius = 26
        loginButton.backgroundColor = UIColor(red: 0.83, green: 0.89, blue: 0.80, alpha: 1.00)
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        loginButton.layer.shadowOpacity = 0.7
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isHelper = false
        self.present(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
}
