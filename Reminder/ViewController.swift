//
//  ViewController.swift
//  Reminder
//
//  Created by Aisultan Askarov on 28.10.2022.
//

import UIKit

extension ViewController {
    
    private struct Const {
        static let ImageSizeForLargeState: CGFloat = 50
        static let ImageRightMargin: CGFloat = 17.5
        static let ImageBottomMarginForLargeState: CGFloat = 0
        static let ImageBottomMarginForSmallState: CGFloat = 3
        static let ImageSizeForSmallState: CGFloat = 40
        static let NavBarHeightSmallState: CGFloat = 44
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
}

class ViewController: UIViewController, UNUserNotificationCenterDelegate, LocalNotificationsModelOutput {

    let titleForNB: UILabel = {
       
        let label = UILabel()

        return label
        
    }()
    
    lazy var addReminderBtn: UIButton = {
       
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular)), for: .normal)
        button.tintColor = UIColor.black
        button.titleLabel?.layer.masksToBounds = false
        button.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        button.titleLabel?.layer.shadowOpacity = 0.5
        button.titleLabel?.layer.shadowRadius = 10
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.addTarget(self, action: #selector(setReminder), for: .touchUpInside)
        
        return button
    }()
    
    private let viewModel: LocalNotificationsModel
    
    init(viewModel: LocalNotificationsModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
      self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization( options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            guard granted else { return }
            self?.getNotificationSettings()
        }
        
        setNavBar()
        setUpSubviews()
        fetchNotifications()
    }

    private func fetchNotifications() {
        viewModel.fetchNotifications()
    }
    
    //MARK: -ViewModelOutput
    func updateView(notifications: [LocalNotifications]) {
        print(notifications)
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    @objc func setReminder() {
        
        let presentViewController = SetReminderView()
        presentViewController.modalPresentationStyle = .custom
        presentViewController.transitioningDelegate = self
        navigationController?.present(presentViewController, animated: true, completion: nil)
        
    }
    
    func setNavBar() {
        
        view.backgroundColor = UIColor.lightGray
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.backgroundColor = UIColor.lightGray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .always
        
        let attributedString = NSMutableAttributedString(string: "Remindme", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30.0, weight: .black)])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 6, length: 2))

        //titleForNB.frame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height)
        titleForNB.textColor = UIColor.white
        titleForNB.attributedText = attributedString
        titleForNB.font = UIFont.systemFont(ofSize: 45.0, weight: .black)
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleForNB)
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(titleForNB)
        
        titleForNB.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleForNB.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 20),
            titleForNB.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -15),
            titleForNB.heightAnchor.constraint(equalToConstant: Const.ImageSizeForSmallState),
            titleForNB.widthAnchor.constraint(equalTo: navigationBar.widthAnchor)
        ])
        
    }
    
    func setUpSubviews() {
        
        view.addSubview(addReminderBtn)
        
        addReminderBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addReminderBtn.widthAnchor.constraint(equalToConstant: 75),
            addReminderBtn.heightAnchor.constraint(equalToConstant: 75),
            addReminderBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addReminderBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        addReminderBtn.layer.cornerRadius = 75/2

    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        var controller: UIPresentationController? = nil
        controller = PresentationController(presentedViewController: presented, presenting: presenting)

        return controller
    }
}
