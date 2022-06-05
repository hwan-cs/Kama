//
//  HelpViewController.swift
//  Kama
//
//  Created by Jung Hwan Park on 2022/05/24.
//

import UIKit
import TweeTextField
import FirebaseFirestore
import CoreLocation
import DropDown

class HelpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    let defaultHeight: CGFloat = 500
    let dismissibleHeight: CGFloat = 250
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 200
    // keep updated with new height
    var currentContainerHeight: CGFloat = 500
    var dropDown = DropDown()
    let scrollView = UIScrollView()
    
    let db = Firestore.firestore()
    
    var user: KamaUser?
    
    var locationManager: CLLocationManager?
    
    var onDismissBlock : ((Bool) -> Void)?
    
    var point = 100
    
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
        titleLabel.layer.cornerRadius = 25
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        return titleLabel
    }()
    
    lazy var helpDetailTitle: UILabel =
    {
        let title = UILabel()
        title.text = "요청 세부사항"
        title.font = .boldSystemFont(ofSize: 16)
        return title
    }()
    
    lazy var helpDetail: UITextView =
    {
        let textView = UITextView()
        textView.text = "   요청 세부사항을 입력하세요"
        textView.textColor = UIColor.lightGray
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 25
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    lazy var dropDownButton: UIButton =
    {
        let dropDownButton = UIButton()
        dropDownButton.backgroundColor = .white
        dropDownButton.layer.borderWidth = 1
        dropDownButton.layer.cornerRadius = 20
        dropDownButton.setTitle("카테고리를 선택하세요", for: .normal)
        dropDownButton.setTitleColor(.black, for: .normal)
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        dropDown.anchorView = dropDownButton
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!-12)
        dropDown.backgroundColor = .white
        dropDown.selectedTextColor = .white
        dropDown.selectionBackgroundColor = UIColor.lightGray
        dropDown.direction = .bottom
        dropDown.cornerRadius = 10
        dropDown.selectionAction =
        { [unowned self] (index: Int, item: String) in
            dropDownButton.setTitle(item, for: .normal)
        }
        let data = ["카테고리 1", "카테고리 2","카테고리 3","카테고리 4","카테고리 5","카테고리 6","카테고리 7","카테고리 8","카테고리 9","카테고리 10"]
        dropDown.dataSource = data
        dropDownButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return dropDownButton
    }()
    
    lazy var deadlineLabel: UILabel =
    {
        let label = UILabel()
        label.text = "데드라인 날짜 및 시간 설정"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var datePicker: UIDatePicker =
    {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ko-KR")
        picker.timeZone = .autoupdatingCurrent
        return picker
    }()
    
    lazy var datePickerView : UIView =
    {
        let foo = UIView()
        foo.addSubview(datePicker)
        foo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        foo.bringSubviewToFront(datePicker)
        return foo
    }()
    
    lazy var pointLabel: UILabel =
    {
        let label = UILabel()
        label.text = "지급할 포인트: \(point) pts"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var registerButton: UIButton =
    {
        let register = UIButton()
        register.setTitle("등록하기", for: .normal)
        register.layer.cornerRadius = 20
        register.setTitleColor(.black, for: .normal)
        register.layer.borderWidth = 1
        register.layer.borderColor = UIColor.black.cgColor
        register.backgroundColor = UIColor(red: 0.83, green: 0.89, blue: 0.80, alpha: 1.00)
        register.heightAnchor.constraint(equalToConstant: 70).isActive = true
        register.addTarget(self, action: #selector(registerHelpTapped), for: .touchUpInside)
        return register
    }()
    
    let foo : UIView =
    {
        let foo = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        foo.backgroundColor = .brown
        return foo
    }()
    
    lazy var contentStackView: UIStackView =
    {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel, titleHelp, helpDetailTitle, helpDetail, dropDownButton, deadlineLabel, datePickerView,  pointLabel, registerButton, foo, spacer])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        stackView.setCustomSpacing(30, after: titleHelp)
        stackView.setCustomSpacing(10.0, after: helpDetailTitle)
        stackView.setCustomSpacing(10.0, after: deadlineLabel)
        stackView.setCustomSpacing(70, after: datePicker)
        stackView.setCustomSpacing(300, after: registerButton)
        return stackView
    }()
    
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboard()
        helpDetail.delegate = self
        locationManager = CLLocationManager()
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
        
        let caLayer = CALayer()
        caLayer.frame = CGRect(x: -15, y: 0, width: UIScreen.main.bounds.width-30, height: 65)
        caLayer.cornerRadius = 25
        caLayer.borderColor = UIColor.lightGray.cgColor
        caLayer.borderWidth = 1
        titleHelp.layer.addSublayer(caLayer)
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
            dropDownButton.heightAnchor.constraint(equalToConstant: 70),
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
    
    //언제 reload??
    @objc func categoryButtonTapped()
    {
        dropDown.show()
    }
    
    @objc func registerHelpTapped()
    {
        let alert = UIAlertController(title: "저장하시겠습니까?", message: "한번 저장하면 다시 바꿀 수 없습니다.", preferredStyle: .alert)
        //예외처리 해야됨
        let action = UIAlertAction(title: "예", style: .default)
        { (action) in
            let ref = self.db.collection("kamaDB").document()
            if let location = self.locationManager?.location
            {
                print(location.coordinate)
                let firestoreLoc = FirebaseFirestore.GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                ref.setData(["userName": self.user!.name, "location": firestoreLoc, "title": self.titleHelp.text!, "time": self.datePicker.date,"category": self.dropDown.selectedItem,
                             "description":self.helpDetail.text!, "uuid": UUID().uuidString, "requestedBy": self.user!.id, "requestAccepted": false, "acceptedBy": "",
                             "point": self.point])
                { error in
                if let e = error
                    {
                        print("There was an issue sending data to Firestore: \(e)")
                    }
                    else
                    {
                        print(self.datePicker.date)
                        self.onDismissBlock!(true)
                        print("Successfully saved data.")
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Alert dismissed")
        }))
        present(alert, animated: true, completion: nil)
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
