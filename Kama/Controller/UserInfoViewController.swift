//
//  UserInfo.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/06/02.
//

import UIKit
import PhotosUI

class UserInfoViewController: UIViewController
{
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var dUserInfoLbl: UILabel!
    
    @IBOutlet var userInfoLblView: UIView!
    
    @IBOutlet var userStatus: UILabel!
    @IBOutlet var userAbout: UILabel!
    
    var user: KamaUser?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        imageView.image = UIImage(systemName: "person.fill")
        if let profileImage = defaults.object(forKey: "profileImage") as? NSData
        {
            if let img = UIImage(data: profileImage as Data)
            {
                self.imageView.image = img
            }
        }
        
        if user!.disabled == true
        {
            userInfoLblView.isHidden = true
            dUserInfoLbl.layer.borderWidth = 1
            dUserInfoLbl.layer.borderColor = UIColor.lightGray.cgColor
            dUserInfoLbl.layer.cornerRadius = 20
            dUserInfoLbl.text = "  Kama User\n  Name: \(user!.name)"
            dUserInfoLbl.font = UIFont.systemFont(ofSize: 14)
            dUserInfoLbl.numberOfLines = 0
        }
        else
        {
            dUserInfoLbl.isHidden = true
            userInfoLblView.layer.borderColor = UIColor.lightGray.cgColor
            userInfoLblView.layer.borderWidth = 1
            userInfoLblView.layer.cornerRadius = 20
            userStatus.font = UIFont.systemFont(ofSize: 14)
            userAbout.font = UIFont.systemFont(ofSize: 14)
            userStatus.layer.borderColor = UIColor.lightGray.cgColor
            userStatus.layer.borderWidth = 1
            userStatus.layer.cornerRadius = 20
            var status = "None"
            let num = self.user!.points!
            if num >= 500
            {
                status = "Apprentice helper"
            }
            if num >= 800
            {
                status = "Novice helper"
            }
            if num >= 1200
            {
                status = "Good Karma"
            }
            if num >= 1600
            {
                status = "Master helper"
            }
            if num >= 2000
            {
                status = "This generation's hero"
            }
            if num >= 5000
            {
                status = "Mother Theresa"
            }
            userStatus.text = "Rank\n\(status)"
            userStatus.textAlignment = .center
            userStatus.numberOfLines = 0
            
            userAbout.text = "   Kama Helper\n   Name: \(self.user!.name)\n   Point: \(self.user!.points ?? 0) pt"
            userAbout.numberOfLines = 0
            userAbout.textAlignment = .center
        }
    }
    
    @objc func didTapChangeProfilePic()
    {
        presentPhotoActionSheet()
    }
    
    @IBAction func dismissView(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showRequestedHelpList(_ sender: UIButton)
    {
        let vc = RequestedHelpListViewController()
        vc.user = self.user!
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    
    @IBAction func showPendingRequestList(_ sender: UIButton)
    {
        let vc = PendingHelpListViewController()
        vc.user = self.user!
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}

extension UserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate
{
    func presentPhotoActionSheet()
    {
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera()
    {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker()
    {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.livePhotos, .images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else
        {
            return
        }
        if let imgData = selectedImage.pngData()
        {
            self.defaults.set(imgData, forKey: "profileImage")
            self.defaults.synchronize()
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        dismiss(animated: true, completion: nil)
        
        guard !results.isEmpty else { return }

        for result in results
        {
            let provider = result.itemProvider

            if provider.canLoadObject(ofClass: UIImage.self)
            {
                 provider.loadObject(ofClass: UIImage.self)
                { (image, error) in
                     DispatchQueue.main.async
                    {
                         if let image = image as? UIImage
                        {
                             self.imageView.image = image
                             if let imgData = image.pngData()
                             {
                                 self.defaults.set(imgData, forKey: "profileImage")
                                 self.defaults.synchronize()
                             }
                         }
                     }
                }
             }
        }
    }
}
