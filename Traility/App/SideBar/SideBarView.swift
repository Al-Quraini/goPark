//
//  SideBarView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/28/23.
//

import UIKit
import MessageUI

protocol SideBarDelegate : AnyObject {
    func goToMyList()
    func sendEmail()
    func shareMyApp()
}

class SideBarView: UIView {
    weak var delegate : SideBarDelegate?
    
    private let iconImage : UIImageView = {
        let icon = UIImageView(image: UIImage(named: "MainIcon"))
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    private let title : UILabel = {
        let label = UILabel()
        label.font = .poppins(size: 30, weight: .semiBold)
        label.text = "goPark"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let divider : UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()

    private let appVersionLabel : UILabel = {
        let label = UILabel()
        label.font = .poppins(size: 12, weight: .light)
        label.text = "version: \(UIApplication.appVersion)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var myList : UIView!
    
    private var share : UIView!
    
    private var reportBug : UIView!
    
    private var followMe : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SideBarView {
    private func setup() {
        myList = ClickableStackView(imageName: "list.bullet", text: "My list", perform: openMyList)
        share = ClickableStackView(imageName: "square.and.arrow.up", text: "Share", perform: shareMyApp)
        reportBug = ClickableStackView(imageName: "ladybug", text: "Report a bug", perform: reportBugEmail)
        followMe = ClickableStackView(imageName: "person.crop.circle.badge.plus", text: "Follow us on twitter", perform: followMeOnTwitter)
        
        addSubview(iconImage)
        addSubview(title)
        addSubview(myList)
        addSubview(reportBug)
        addSubview(share)
        addSubview(followMe)
        addSubview(divider)
        addSubview(appVersionLabel)
        
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImage.widthAnchor.constraint(equalToConstant: 50),
            iconImage.heightAnchor.constraint(equalToConstant: 50),
            
            title.centerYAnchor.constraint(equalTo: iconImage.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            myList.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 25),
            myList.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            myList.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            myList.heightAnchor.constraint(equalToConstant: 50),
            
            reportBug.topAnchor.constraint(equalTo: myList.bottomAnchor, constant: 10),
            reportBug.leadingAnchor.constraint(equalTo: myList.leadingAnchor),
            reportBug.trailingAnchor.constraint(equalTo: myList.trailingAnchor, constant: -15),
            reportBug.heightAnchor.constraint(equalToConstant: 50),
            
            share.topAnchor.constraint(equalTo: reportBug.bottomAnchor, constant: 10),
            share.leadingAnchor.constraint(equalTo: myList.leadingAnchor),
            share.trailingAnchor.constraint(equalTo: myList.trailingAnchor, constant: -15),
            share.heightAnchor.constraint(equalToConstant: 50),
            
            followMe.topAnchor.constraint(equalTo: share.bottomAnchor, constant: 10),
            followMe.leadingAnchor.constraint(equalTo: myList.leadingAnchor),
            followMe.trailingAnchor.constraint(equalTo: myList.trailingAnchor, constant: -15),
            followMe.heightAnchor.constraint(equalToConstant: 50),
            
            divider.topAnchor.constraint(equalTo: followMe.bottomAnchor, constant: 20),
            divider.widthAnchor.constraint(equalTo : widthAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            appVersionLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 30),
            appVersionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func openMyList() {
        delegate?.goToMyList()
    }
    
    private func reportBugEmail() {
        delegate?.sendEmail()
    }
    
    
    private func followMeOnTwitter() {
        LinkManager().goToGoParkAppTwitterProfile()
    }
    
    private func shareMyApp() {
        delegate?.shareMyApp()
    }
}
