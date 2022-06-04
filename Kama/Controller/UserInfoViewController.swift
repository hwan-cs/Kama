//
//  UserInfo.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/06/02.
//

import UIKit

class UserInfoViewController: UIViewController
{
    override func viewDidLoad()
    {
        print("viewdidload")
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    @IBAction func dismissView(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
