//
//  MailManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/2/23.
//

import MessageUI

struct MailManager {
    
    func sendEmail(nav : UINavigationController) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["alquraini.dev@gmail.com"])
            nav.present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            // give feedback to the user
            let alert = UIAlertController(title: "", message: "Email is not configured ", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                // Handle dismissal of alert
            })
            alert.addAction(dismissAction)
            nav.present(alert, animated: true)
        }
    }
}
