//
//  HelpViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/24.
//

import UIKit
import TweeTextField

class HelpViewController: UIViewController, UITextFieldDelegate
{
    
    let defaultHeight: CGFloat = 400
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep updated with new height
    var currentContainerHeight: CGFloat = 300
    
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
        label.text = "도움 요청하기"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var titleHelp: TweeAttributedTextField =
    {
        let titleLabel = TweeAttributedTextField()
        titleLabel.delegate = self
        titleLabel.infoTextColor = UIColor.systemBlue
        titleLabel.infoAnimationDuration = 0.2
        titleLabel.infoFontSize = 14
        titleLabel.activeLineColor = .systemBlue
        titleLabel.activeLineWidth = 1
        titleLabel.animationDuration = 0.2
        titleLabel.lineColor = .lightGray
        titleLabel.placeholderColor = .lightGray
        titleLabel.placeholderInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        titleLabel.lineWidth = 1
        titleLabel.tweePlaceholder = "제목"
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.layer.cornerRadius = 22
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        return titleLabel
    }()
    
    lazy var contentStackView: UIStackView =
    {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, titleHelp, spacer])
        stackView.axis = .vertical
        stackView.bringSubviewToFront(titleHelp)
        stackView.spacing = 30.0
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
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let caLayer = CALayer()
        caLayer.frame = CGRect(x: -30, y: 0, width: UIScreen.main.bounds.width-40, height: 65)
        caLayer.cornerRadius = 30
        caLayer.borderColor = UIColor.lightGray.cgColor
        caLayer.borderWidth = 1
        titleHelp.layer.addSublayer(caLayer)
        // 5. Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            
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
//        animateShowDimmedView()
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
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer)
    {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")

        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")

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
}
extension CALayer
{
    func innerBorder(borderOffset: CGFloat = 24.0, borderColor: UIColor = UIColor.blue, borderWidth: CGFloat = 2)
    {
        let innerBorder = CALayer()
        innerBorder.frame = CGRect(x: borderOffset, y: borderOffset, width: frame.size.width - 2 * borderOffset, height: frame.size.height - 2 * borderOffset)
        innerBorder.borderColor = borderColor.cgColor
        innerBorder.borderWidth = borderWidth
        innerBorder.name = "innerBorder"
        insertSublayer(innerBorder, at: 0)
    }
}
