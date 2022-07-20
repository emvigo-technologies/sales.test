import Foundation
import MessageUI

struct MailData {
    let recipients: String
    let subject: String
    let body: String
}

class VMCMailManager: NSObject, MFMailComposeViewControllerDelegate {
    private var mailData: MailData
    private var completion: ((Result<MFMailComposeResult,Error>)->Void)?
    
    override init() {
        fatalError("Use FeedbackManager(feedback:)")
    }
    
    init?(mailData: MailData) {
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }
        self.mailData = mailData
    }
    
    func send(on viewController: UIViewController, completion:(@escaping(Result<MFMailComposeResult,Error>)->Void)) {
        let mailVC = MFMailComposeViewController()
        self.completion = completion
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([mailData.recipients])
        mailVC.setSubject(mailData.subject)
        mailVC.setMessageBody(mailData.body, isHTML: false)
        viewController.present(mailVC, animated:true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            completion?(.failure(error))
        } else {
            completion?(.success(result))
        }
    }
}
