//
//  DetailViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/30.
//

import UIKit
import TweeTextField
import FirebaseFirestore
import CoreLocation
import DropDown

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    let defaultHeight: CGFloat = 550
    let dismissibleHeight: CGFloat = 250
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 200
    // keep updated with new height
    var currentContainerHeight: CGFloat = 300
    var dropDown = DropDown()
    let scrollView = UIScrollView()
    
    let db = Firestore.firestore()
    
    var help: KamaHelp?
    var user: KamaUser?
    
    // 1
    lazy var containerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.92, alpha: 1.00)
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
        label.text = "제목"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var titleHelp: UILabel =
    {
        let titleLabel = UILabel()
        titleLabel.text = "\t\(help!.name)"
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.layer.cornerRadius = 25
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        titleLabel.layer.cornerRadius = 25
        titleLabel.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.layer.borderWidth = 1
        return titleLabel
    }()
    
    lazy var helpDetailTitle: UILabel =
    {
        let title = UILabel()
        title.text = "요청 세부사항"
        title.font = .boldSystemFont(ofSize: 16)
        return title
    }()
    
    lazy var helpDetail: UILabel =
    {
        let textView = UILabel()
        textView.text = "\t\(help!.description!)"
        textView.textColor = UIColor.lightGray
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 25
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    lazy var categoryTitle: UILabel =
    {
        let title = UILabel()
        title.text = "카테고리"
        title.font = .boldSystemFont(ofSize: 20)
        return title
    }()
    
    lazy var categoryLabel: UILabel =
    {
        let categoryLabel = UILabel()
        categoryLabel.text = "\t\(help!.category)"
        categoryLabel.font = .systemFont(ofSize: 16)
        categoryLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        categoryLabel.layer.cornerRadius = 25
        categoryLabel.layer.borderWidth = 1
        categoryLabel.layer.borderColor = UIColor.lightGray.cgColor
        return categoryLabel
    }()
    
    lazy var deadlineTitle: UILabel =
    {
        let label = UILabel()
        label.text = "데드라인"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var deadlineLabel: UILabel =
    {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        label.text = formatter.string(from: help!.time.dateValue())
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var pointLabel: UILabel =
    {
        let label = UILabel()
        label.text = "포인트: "
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var userName: UILabel =
    {
        let label = UILabel()
        label.text = "도움 요청인: \(help!.user)"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
        
    lazy var okButton: UIButton =
    {
        let register = UIButton()
        register.setTitle(user!.disabled == true ? "확인" : "수락하기", for: .normal)
        register.layer.cornerRadius = 25
        register.setTitleColor(.black, for: .normal)
        register.layer.borderWidth = 1
        register.layer.borderColor = UIColor.black.cgColor
        register.backgroundColor = UIColor(red: 0.83, green: 0.89, blue: 0.80, alpha: 1.00)
        register.heightAnchor.constraint(equalToConstant: 70).isActive = true
        register.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return register
    }()
    
    lazy var contentStackView: UIStackView =
    {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, titleHelp, helpDetailTitle, helpDetail, categoryTitle, categoryLabel, deadlineTitle, deadlineLabel,
                                                       pointLabel, userName, okButton, spacer])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        return stackView
    }()
    
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboard()
        setupView()
        setupConstraints()
        setupPanGesture()
    }
    
    func setupView()
    {
        view.backgroundColor = .clear
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
    
    @objc func okButtonTapped()
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
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = "   요청 세부사항을 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
}
