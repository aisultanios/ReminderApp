//
//  ReminderCell.swift
//  Reminder
//
//  Created by Aisultan Askarov on 2.11.2022.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    let viewForCell: UIView = {
                    
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 7.5
        //view.contentMode = .scaleToFill
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.35
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return view
    }()

    let titleOfReminder: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.5, weight: .medium)
        label.allowsDefaultTighteningForTruncation = false
        label.numberOfLines = 2
        label.textColor = .black.withAlphaComponent(1.0)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        
        return label
    }()
    
    let dateOfReminder: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .black.withAlphaComponent(0.75)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        addSubview(viewForCell)
        viewForCell.addSubview(titleOfReminder)
        viewForCell.addSubview(dateOfReminder)
        
        viewForCell.translatesAutoresizingMaskIntoConstraints = false
        titleOfReminder.translatesAutoresizingMaskIntoConstraints = false
        dateOfReminder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewForCell.topAnchor.constraint(equalTo: topAnchor, constant: 7.5),
            viewForCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7.5),
            viewForCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            viewForCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            titleOfReminder.topAnchor.constraint(equalTo: viewForCell.topAnchor, constant: 15),
            titleOfReminder.leadingAnchor.constraint(equalTo: viewForCell.leadingAnchor, constant: 15),
            titleOfReminder.trailingAnchor.constraint(equalTo: viewForCell.trailingAnchor, constant: -20),
        ])
        titleOfReminder.sizeToFit()
        
        NSLayoutConstraint.activate([
            dateOfReminder.topAnchor.constraint(equalTo: titleOfReminder.bottomAnchor, constant: 5),
            dateOfReminder.leadingAnchor.constraint(equalTo: viewForCell.leadingAnchor, constant: 15),
            dateOfReminder.trailingAnchor.constraint(equalTo: viewForCell.trailingAnchor, constant: -20),
        ])
        dateOfReminder.sizeToFit()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
