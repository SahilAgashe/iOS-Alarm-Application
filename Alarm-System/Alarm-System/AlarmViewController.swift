//
//  AlarmViewController.swift
//  Alarm-System
//
//  Created by Sahil Agashe on 01/04/23.
//

import UIKit
import UserNotifications

protocol  AlarmViewControllerDelegate: AnyObject {
    func updateAlarmsArray(newAlarm: LocalNotification)
    func updateAlarm(updatedAlarm: LocalNotification)
    func turnOffAlarmSwitch(alarmIdentifier: String)
    func turnOnAlarmSwitch(alarmIdentifier: String)
}

class AlarmViewController: UIViewController {
    
    weak var delegate: AlarmViewControllerDelegate?
    private let currentNotificationCenter = UNUserNotificationCenter.current()
    private var notificationIdentifier: String = ""
    private var isNotificationAlreadyExists: Bool = false
    private var alarmNotification: LocalNotification?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Title"
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Message"
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let snoozeLabel: UILabel = {
        let label = UILabel()
        label.text = "Snooze"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let snoozeSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.preferredStyle = .sliding
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.onTintColor = .red
        switchButton.thumbTintColor = .white
        switchButton.isOn = false
        switchButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.8);
        return switchButton
    }()
    
    let scheduleNotificationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Schedule Alarm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 10.0
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(scheduleNotificationButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        titleTextField.text = ""
        messageTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: CGFloat(245/255.0), green: CGFloat(245/255.0), blue: CGFloat(245/255.0), alpha: CGFloat(1.0))
        view.addSubview(titleTextField)
        view.addSubview(messageTextField)
        view.addSubview(datePicker)
        view.addSubview(snoozeLabel)
        view.addSubview(snoozeSwitch)
        view.addSubview(scheduleNotificationButton)
        
        setupConstraints()
        
        // Request permission to display notifications.
        currentNotificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { (permissionGranted, error) in
            if permissionGranted{
                print("Notication permission granted")
            } else {
                print("Notication permission denied")
            }
        }
        
        // Set the notification center delegate to handle notifications.
        currentNotificationCenter.delegate = self;
    }
    
    private func setupConstraints()
    {
        NSLayoutConstraint.activate([
            // titleTextField
            self.titleTextField.heightAnchor.constraint(equalToConstant: 45),
            self.titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            self.titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            // messageTextField
            self.messageTextField.heightAnchor.constraint(equalToConstant: 45),
            self.messageTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            self.messageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.messageTextField.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: 5),
            
            // datePicker
            self.datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.datePicker.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: 10),
            datePicker.heightAnchor.constraint(equalToConstant: 150),
            
            // snoozeLabel
            snoozeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35),
            snoozeLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            
            // snoozeSwitch
            snoozeSwitch.leadingAnchor.constraint(equalTo: snoozeLabel.trailingAnchor, constant: 20),
            snoozeSwitch.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 11),
            snoozeSwitch.widthAnchor.constraint(equalToConstant: 30),
            snoozeSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            
            // scheduleNotificationButton
            self.scheduleNotificationButton.widthAnchor.constraint(equalToConstant: 170),
            self.scheduleNotificationButton.heightAnchor.constraint(equalToConstant: 40),
            self.scheduleNotificationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.scheduleNotificationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func scheduleNotificationButtonAction()
    {
        scheduleNotification()
        dismiss(animated: true, completion: nil)
    }
    
    private func scheduleNotification() {
        // Create notification content object.
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? ""
        content.subtitle = "Alarm Notification"
        content.body = messageTextField.text ?? ""
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "alarmCategory"
        
        let alarmDate = datePicker.date
        let alarmDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarmDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmDateComponents, repeats: snoozeSwitch.isOn)
        
        let snoozeAction = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: UNNotificationActionOptions.init())
        let stopAction = UNNotificationAction(identifier: "stopAction", title: "Stop", options: UNNotificationActionOptions.init())
        
        if trigger.repeats {
            let alarmCategryWithSnooze = UNNotificationCategory(identifier: "alarmCategory", actions: [snoozeAction,stopAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
            currentNotificationCenter.setNotificationCategories([alarmCategryWithSnooze])
        }
        else {
            let alarmCategryWithoutSnooze = UNNotificationCategory(identifier: "alarmCategory", actions: [stopAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
            currentNotificationCenter.setNotificationCategories([alarmCategryWithoutSnooze])
        }
        
        if isNotificationAlreadyExists {
            alarmNotification?.updateNotification(newContent: content, newTrigger: trigger, newDate: datePicker.date)
            addNotification(content: content, trigger: trigger, notificationIdentifier: notificationIdentifier)
            delegate?.updateAlarm(updatedAlarm: alarmNotification ?? LocalNotification())
            delegate?.turnOnAlarmSwitch(alarmIdentifier: notificationIdentifier)
        }
        else {
            // creating unique notification identifier string
            //from (content.title + current-date + current-time)
            let date = Date()
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            let hour = Calendar.current.component(.hour, from: date)
            let minutes = Calendar.current.component(.minute, from: date)
            let seconds = Calendar.current.component(.second, from: date)
            let nanoseconds = Calendar.current.component(.nanosecond, from: date)
            notificationIdentifier = content.title + String(year) + String(month) + String(day) + String(hour) + String(minutes) + String(seconds) + String(nanoseconds)
            
            addNotification(content: content, trigger: trigger, notificationIdentifier: notificationIdentifier)
            
            //adding alarm in ViewController
            let  alarmNotification = LocalNotification(notificationIdentifier: notificationIdentifier, content: content, trigger: trigger, date: datePicker.date)
            delegate?.updateAlarmsArray(newAlarm: alarmNotification)
            delegate?.turnOnAlarmSwitch(alarmIdentifier: notificationIdentifier)
        }
        
        alarmNotification = nil
        isNotificationAlreadyExists = false
    }
    
    func addNotification(content: UNNotificationContent,trigger: UNNotificationTrigger?, notificationIdentifier: String) {
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        currentNotificationCenter.add(request, withCompletionHandler: {
            (errorObject) in
            if let error = errorObject {
                print("Error \(error.localizedDescription) in notification \(notificationIdentifier)")
            }
        })
    }
    
    func removeNotification(notificationIdentifier: String) {
        currentNotificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
    
    func setupInitialStatesOfAlarm(notification: LocalNotification) {
        titleTextField.text = notification.content?.title
        messageTextField.text = notification.content?.body
        datePicker.date = notification.date ?? Date()
        isNotificationAlreadyExists = true
        notificationIdentifier = notification.notificationIdentifier ?? ""
        alarmNotification = notification
        return
    }
}


// MARK: - UNUserNotificationCenterDelegate

extension AlarmViewController: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        let request = response.notification.request
        
        if response.actionIdentifier == "snoozeAction" {
            
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            newContent.title = request.content.title
            newContent.body = request.content.body
            newContent.subtitle = "Snooze for 5 Seconds"
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            addNotification(content: newContent, trigger: newTrigger, notificationIdentifier: request.identifier)
        }
        else if response.actionIdentifier == "stopAction" {
            removeNotification(notificationIdentifier: request.identifier)
            delegate?.turnOffAlarmSwitch(alarmIdentifier: request.identifier)
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner])
        let request = notification.request
        if request.trigger?.repeats == true {
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            newContent.title = request.content.title
            newContent.subtitle = "Snooze With 1 Minute Interval"
            newContent.body = request.content.body
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            addNotification(content: newContent, trigger: newTrigger, notificationIdentifier: request.identifier)
        }
    }
    
}
