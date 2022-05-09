//
//  ViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/01.
//

import UIKit
import Gifu

class MainViewController: UIViewController
{
    @IBOutlet var needHelpButton: UIButton!
    @IBOutlet var giveHelpButton: UIButton!
    
    @IBOutlet var registerScreenGif: GIFImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        registerScreenGif.animate(withGIFNamed: "registerScreen_gif")
        needHelpButton.backgroundColor = UIColor(red: 0.57, green: 0.89, blue: 0.65, alpha: 1.00)
        giveHelpButton.backgroundColor = UIColor(red: 0.80, green: 0.95, blue: 0.96, alpha: 1.00)
        needHelpButton.layer.cornerRadius = 28
        giveHelpButton.layer.cornerRadius = 28
    }
}

