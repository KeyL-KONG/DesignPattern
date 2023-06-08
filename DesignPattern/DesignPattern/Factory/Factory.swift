//
//  Factory.swift
//  DesignPattern
//
//  Created by LQ on 2023/5/27.
//

import Foundation

public struct JobApplicant {
    public let name: String
    public let email: String
    public var status: Status
    
    public enum Status {
        case new
        case interview
        case hired
        case rejected
    }
}

public struct Email {
    public let subject: String
    public let messageBody: String
    public let recipientEmail: String
    public let senderEmail: String
}

public struct EmailFactory {
    public let senderEmail: String
    
    public func createEmail(to recipient: JobApplicant) -> Email {
        let subject: String
        let messageBody: String
        
        switch recipient.status {
        case .new:
            subject = "new"
            messageBody = "new"
        case .interview:
            subject = "interview"
            messageBody = "interview"
        case .hired:
            subject = "hired"
            messageBody = "hired"
        case .rejected:
            subject = "rejected"
            messageBody = "rejected"
        }
        return Email(subject: subject, messageBody: messageBody, recipientEmail: recipient.email, senderEmail: senderEmail)
    }
}


func createEmail() {
    var jackson = JobApplicant(name: "jackson", email: "jackson@example.com", status: .new)
    let emailFactory = EmailFactory(senderEmail: "Rays@example.com")
    print(emailFactory.createEmail(to: jackson))
    jackson.status = .interview
    print(emailFactory.createEmail(to: jackson))
    jackson.status = .hired
    print(emailFactory.createEmail(to: jackson))
}
