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
    
    let tableView: UITableView = {
       
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .default
        tableView.showsHorizontalScrollIndicator = false
        tableView.isPagingEnabled = false
        tableView.register(ReminderCell.self, forCellReuseIdentifier: "Cell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        return tableView
    }()
    
    let viewModel: LocalNotificationsModel
    
    init(viewModel: LocalNotificationsModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
      self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    var notifications: [UNNotificationRequest] = []
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization( options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            guard granted else { return }
            self?.getNotificationSettings()
        }
        
        setNavBar()
        fetchNotifications()
    }

    func fetchNotifications() {
        viewModel.fetchNotifications()
    }
    
    //MARK: -ViewModelOutput
    func updateView(notifications: [UNNotificationRequest]) {
        if notifications.count == 0 {
            setUpSubviews(hasNotifications: false)
        } else if notifications.count > 0 {
            self.notifications = notifications
            setUpSubviews(hasNotifications: true)
        }
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
        presentViewController.vc = self
        presentViewController.modalPresentationStyle = .custom
        presentViewController.transitioningDelegate = self
        navigationController?.present(presentViewController, animated: true, completion: nil)
        
    }
    
    func setNavBar() {
        
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.175)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
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
            titleForNB.widthAnchor.constraint(equalToConstant: navigationBar.frame.width / 1.5)
        ])
        
    }
    
    func setUpSubviews(hasNotifications: Bool) {
        
        DispatchQueue.main.async { [self] in
            
            guard let navigationBar = self.navigationController?.navigationBar else { return }
            addReminderBtn.removeFromSuperview()
            
            if hasNotifications == false {
                
                view.addSubview(addReminderBtn)
                addReminderBtn.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.deactivate([
                    addReminderBtn.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -20),
                    addReminderBtn.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -15),
                    addReminderBtn.heightAnchor.constraint(equalToConstant: 40),
                    addReminderBtn.widthAnchor.constraint(equalToConstant: 40)
                ])
                
                NSLayoutConstraint.activate([
                    addReminderBtn.widthAnchor.constraint(equalToConstant: 75),
                    addReminderBtn.heightAnchor.constraint(equalToConstant: 75),
                    addReminderBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    addReminderBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
                addReminderBtn.layer.cornerRadius = 75/2
                addReminderBtn.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular)), for: .normal)
                
                tableView.removeFromSuperview()

            } else if hasNotifications == true {
                
                navigationBar.addSubview(addReminderBtn)
                
                addReminderBtn.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.deactivate([
                    addReminderBtn.widthAnchor.constraint(equalToConstant: 75),
                    addReminderBtn.heightAnchor.constraint(equalToConstant: 75),
                    addReminderBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    addReminderBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
                
                NSLayoutConstraint.activate([
                    addReminderBtn.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -20),
                    addReminderBtn.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -15),
                    addReminderBtn.heightAnchor.constraint(equalToConstant: 40),
                    addReminderBtn.widthAnchor.constraint(equalToConstant: 40)
                ])
                addReminderBtn.layer.cornerRadius = 40/2
                addReminderBtn.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20.0, weight: .regular)), for: .normal)
                
                view.addSubview(tableView)
                tableView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])

                tableView.dataSource = self
                tableView.delegate = self
                tableView.reloadData()

            }
            
            view.layoutSubviews()
        }
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReminderCell
        cell.titleOfReminder.text = notifications[indexPath.row].content.body
        dateFormatter.dateStyle = .full
        cell.dateOfReminder.text = dateFormatter.string(from: notifications[indexPath.row].content.userInfo["date"] as! Date)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let alertController = UIAlertController(title: "Do you want to delete this reminder?", message: "This action is irreversible!", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
                    
                //deletes reminder from coredata and erases pending local notification
                deleteReminder(remindersTitle: notifications[indexPath.row].identifier, indexPath: indexPath)

            })
                       
            present(alertController, animated: true)
            
        }
        
    }
    
    func deleteReminder(remindersTitle: String, indexPath: IndexPath) {
        notifications.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [remindersTitle])
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        var controller: UIPresentationController? = nil
        controller = PresentationController(presentedViewController: presented, presenting: presenting)

        return controller
    }
}
