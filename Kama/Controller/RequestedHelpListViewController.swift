//
//  RequestedHelpListViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/06/05.
//

import UIKit
import FirebaseFirestore

class RequestedHelpListViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    let defaultHeight: CGFloat = 500
    let dismissibleHeight: CGFloat = 250
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 200
    // keep updated with new height
    var currentContainerHeight: CGFloat = 500
    let scrollView = UIScrollView()
    
    let db = Firestore.firestore()
    
    var count = 0
    var helpList = [KamaHelp]()
    
    var user: KamaUser?
    
    let dispatchGroup = DispatchGroup()
    
    var contentStackView =  UIStackView()
    
    // 1
    lazy var containerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // 2
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView =
    {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    lazy var titleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "List of help requested"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboard()
        dispatchGroup.enter()
        self.loadData()
        dispatchGroup.notify(queue: .main)
        {
            self.setupView()
            self.setupConstraints()
            self.setupPanGesture()
        }
    }
    
    func setupView()
    {
        view.backgroundColor = .clear
        let spacer = UIView()
        let numLabel = UILabel()
        numLabel.text = "Total of \(self.count)"
        let line = UIView()
        line.backgroundColor = .lightGray
        line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        contentStackView = UIStackView(arrangedSubviews: [titleLabel, numLabel, line])
        for help in helpList
        {
            let helpLabel = UILabel()
            helpLabel.layer.cornerRadius = 20
            helpLabel.layer.borderColor = UIColor.lightGray.cgColor
            helpLabel.layer.borderWidth = 1
            helpLabel.numberOfLines = 2
            helpLabel.adjustsFontSizeToFitWidth = true
            helpLabel.text = "   \(help.title), \(help.userName), \(help.point) pts, \(help.category)"
            helpLabel.textAlignment = .left
            helpLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
            contentStackView.addArrangedSubview(helpLabel)
        }
        contentStackView.addArrangedSubview(spacer)
        contentStackView.setCustomSpacing(10, after: numLabel)
       // contentStackView.alignment = .center
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalCentering
        contentStackView.spacing = 30
        
    }
    
    func loadData()
    {
        db.collection("kamaDB").whereField("uuid", isNotEqualTo: false).getDocuments
        { querySnapShot, error in
            if let e = error
            {
                print("There was an issue retrieving data from Firestore \(e)")
            }
            else
            {
                if let snapshotDocuments = querySnapShot?.documents
                {
                    for doc in snapshotDocuments
                    {
                        let data = doc.data()
                        print(self.user!.id)
                        if data["requestedBy"] as! String == self.user!.id
                        {
                            let kama = KamaHelp(category: data["category"] as! String, point: data["point"] as! Int, userName: data["userName"] as! String, requestAccepted: data["requestAccepted"] as! Bool, title: data["title"] as! String)
                            self.count += 1
                            self.helpList.append(kama)
                        }
                    }
                    self.dispatchGroup.leave()
                }
            }
        }
    }
    
    func setupConstraints()
    {
        // 4. Add subviews
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(dimmedView)
        //view.addSubview(scrollView)
        view.addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    
        // 5. Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
        ])
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview

            ])
        // 6. Set container to default height
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        // 7. Set bottom constant to 0
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func animatePresentContainer()
    {
        // Update bottom constraint in animation block
        UIView.animate(withDuration: 0.3)
        {
            self.containerViewBottomConstraint?.constant = 0
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView()
    {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4)
        {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //animateShowDimmedView()
        animatePresentContainer()
    }
    
    func animateDismissView()
    {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3)
        {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4)
        {
            self.dimmedView.alpha = 0
        }
        completion:
        { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
    }
    
    func setupPanGesture()
    {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func dismissOnTap()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa

        // Get drag direction
        let isDraggingDown = translation.y > 0

        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y

        // Handle based on gesture state
        switch gesture.state
        {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight
            {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight
            {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight
            {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown
            {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown
            {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func showAlert(_ message:String, _ width: Int, _ height: Int, completionHandler: @escaping () -> Void)
    {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 35, y: 50, width: width, height: height))
        alert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        let width = NSLayoutConstraint(item: alert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in alert.dismiss(animated: true) {
            completionHandler()
        }} )
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        animateContainerHeight(maximumContainerHeight)
    }
    
    func animateContainerHeight(_ height: CGFloat)
    {
        UIView.animate(withDuration: 0.4)
        {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

