//
//  ViewController.swift
//  Alarm-System
//
//  Created by Sahil Agashe on 31/03/23.
//


import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    let customColor = UIColor(red: CGFloat(242/255.0), green: CGFloat(242/255.0), blue: CGFloat(242/255.0), alpha: CGFloat(1.0))
    
    let alarmViewController = AlarmViewController()
    var alarmsArray = [LocalNotification]()
    var indexToUpdateAlarm: Int = -1
    
    let addButton: UIButton = {
        let image = UIImage(named: "addButton.png")
        let button = UIButton()
        button.setBackgroundImage(image, for: UIControl.State.normal)
        button.addTarget(ViewController.self, action:#selector(addButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView = UITableView()
    
    let noAlarmsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Alarms"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: CGFloat(245/255.0), green: CGFloat(245/255.0), blue: CGFloat(245/255.0), alpha: CGFloat(1.0))
        
        addButton.backgroundColor = view.backgroundColor
        view.addSubview(noAlarmsLabel)
        setupTableView()

        // if alarmsArray has alarms
        if alarmsArray.count > 0 {
            noAlarmsLabel.isHidden = true
        }
        
        view.addSubview(addButton)
        setupConstraints()
        alarmViewController.delegate = self
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmsTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func  setupConstraints() {
        NSLayoutConstraint.activate([
            
            // noAlarmsLabel
            noAlarmsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAlarmsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            // tableView
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // addButton
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    @objc func addButtonAction() {
        self.present(alarmViewController, animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDataSource and UIableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AlarmsTableViewCell {
            cell.titleLabel.text  = alarmsArray[indexPath.row].title
            cell.messageLabel.text = alarmsArray[indexPath.row].body
            cell.timeLabel.text = alarmsArray[indexPath.row].alarmTimeString
            cell.alarmSwitch.tag = indexPath.row
            cell.alarmSwitch.addTarget(self, action: #selector(alarmSwitchAction(_:)), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        indexToUpdateAlarm = indexPath.row
        alarmViewController.setupInitialStatesOfAlarm(notification: alarmsArray[indexPath.row])
        present(alarmViewController, animated: true, completion: nil)
    }
    
    @objc func alarmSwitchAction(_ sender : UISwitch) {
        if sender.isOn {
            let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AlarmsTableViewCell
            cell.backgroundColor = .white
            alarmViewController.addNotification(content: alarmsArray[sender.tag].content ?? UNNotificationContent(), trigger: alarmsArray[sender.tag].trigger, notificationIdentifier: alarmsArray[sender.tag].notificationIdentifier ?? "")
        }
        else {
            let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AlarmsTableViewCell
            cell.backgroundColor = customColor
            alarmViewController.removeNotification(notificationIdentifier: alarmsArray[sender.tag].notificationIdentifier ?? "")
        }
    }
    
    @objc func deleteButtonAction(_ sender : UIButton) {
        alarmViewController.removeNotification(notificationIdentifier: alarmsArray[sender.tag].notificationIdentifier ?? "")
        alarmsArray.remove(at: sender.tag)
        tableView.reloadData()
        if alarmsArray.count == 0 {
            noAlarmsLabel.isHidden = false
        }
    }
    
}

// MARK: AlarmViewControllerDelegate

extension ViewController: AlarmViewControllerDelegate {
    
    func updateAlarmsArray(newAlarm: LocalNotification) {
        alarmsArray.append(newAlarm)
        tableView.reloadData()
        if alarmsArray.count > 0 {
            noAlarmsLabel.isHidden = true
        }
    }
    
    func updateAlarm(updatedAlarm: LocalNotification)
    {
        alarmsArray[indexToUpdateAlarm] = updatedAlarm
        tableView.reloadData()
    }
    
    func turnOffAlarmSwitch(alarmIdentifier: String) {
        for index in 0..<alarmsArray.count {
            if alarmsArray[index].notificationIdentifier ?? "" == alarmIdentifier {
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! AlarmsTableViewCell
                cell.alarmSwitch.isOn = false
                cell.backgroundColor = customColor
            }
        }
    }
    
    func turnOnAlarmSwitch(alarmIdentifier: String) {
        for index in 0..<alarmsArray.count {
            if alarmsArray[index].notificationIdentifier ?? "" == alarmIdentifier {
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! AlarmsTableViewCell
                cell.alarmSwitch.isOn = true
                cell.backgroundColor = .white
            }
        }
    }
    
}




