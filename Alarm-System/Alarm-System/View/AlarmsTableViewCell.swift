//
//  AlarmsTableViewCell.swift
//  Alarm-System
//
//  Created by Sahil Agashe on 01/04/23.
//

import UIKit

class AlarmsTableViewCell: UITableViewCell
{
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let alarmSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.preferredStyle = .sliding
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.onTintColor = .red
        switchButton.thumbTintColor = .white
        switchButton.isOn = true
        
        switchButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.8);
        return switchButton
    }()
    
    let deleteButton: UIButton = {
        let image = UIImage(named: "deleteIcon.png")
        let button = UIButton()
        button.setBackgroundImage(image, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell()
    {
        self.backgroundColor = .white
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(alarmSwitch)
        contentView.addSubview(deleteButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // timeLabel
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            // messageLabel
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            // alarmSwitch
            alarmSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            alarmSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            alarmSwitch.widthAnchor.constraint(equalToConstant: 30),
            alarmSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            // deleteButton
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            deleteButton.topAnchor.constraint(equalTo: alarmSwitch.bottomAnchor, constant: 2),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
}
