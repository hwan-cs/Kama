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
    @IBOutlet var registerScreenGif: GIFImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Init pods")
        registerScreenGif.animate(withGIFNamed: "registerScreen_gif")
        // Do any additional setup after loading the view.
    }
}

