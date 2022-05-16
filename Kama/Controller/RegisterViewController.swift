//
//  ViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/01.
//

import UIKit
import Gifu

class RegisterViewController: UIViewController
{
    @IBOutlet var needHelpButton: UIButton!
    @IBOutlet var giveHelpButton: UIButton!
    
    @IBOutlet var registerScreenGif: GIFImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.92, alpha: 1.00)
        registerScreenGif.animate(withGIFNamed: "registerScreen_gif")
        needHelpButton.backgroundColor = UIColor(red: 0.76, green: 0.77, blue: 0.50, alpha: 1.00)
        needHelpButton.layer.shadowColor = UIColor.black.cgColor
        needHelpButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        needHelpButton.layer.shadowOpacity = 0.7
        giveHelpButton.backgroundColor = UIColor(red: 0.67, green: 0.74, blue: 0.53, alpha: 1.00)
        giveHelpButton.layer.shadowColor = UIColor.black.cgColor
        giveHelpButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        giveHelpButton.layer.shadowOpacity = 0.7
        needHelpButton.layer.cornerRadius = 28
        giveHelpButton.layer.cornerRadius = 28
    }
}

