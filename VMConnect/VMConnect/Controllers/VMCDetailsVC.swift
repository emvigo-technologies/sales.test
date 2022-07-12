import UIKit
import MessageUI

class VMCDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var bgView: UIView!
    var contactData: VMCContactModelElement?
    var titleList = ["Created","Mail","Favorite Color"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.bgView.roundCorners( [.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 3
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! VMCDetailHeaderTVCell
            cell.selectionStyle = .none
            if let imgUrlString = self.contactData?.avatar{
                if !(imgUrlString.isEmpty){
                    cell.userImageView.setImage(filePath: imgUrlString, placeholderImage: UIImage(named: "contactPlaceHolder"))
                }
            }
            cell.nameLabel.text = "\(self.contactData?.firstName ?? "")" + "\(self.contactData?.lastName ?? "")"
            cell.jobTitleLabel.text = "\(self.contactData?.jobtitle ?? "")"
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell0", for: indexPath) as! VMCDetailTVCell
            cell.selectionStyle = .none
            cell.titleLabel.text = self.titleList[indexPath.row]
            if indexPath.row == 0{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let date = dateFormatter.date(from: self.contactData?.createdAt ?? "")
                dateFormatter.dateFormat = "MMM d, yyyy"
                let resultString = dateFormatter.string(from: date!)
                cell.nameLabel.text = resultString
            }else if indexPath.row == 1{
                cell.nameLabel.text = self.contactData?.email ?? ""
            }else{
                cell.nameLabel.text = self.contactData?.favouriteColor?.capitalized ?? ""
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! VMCSubDetailTVCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func callBtnClick(sender: UIButton){
        VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.callUnavailableMsg)
    }
    
    @IBAction func messageBtnClick(sender: UIButton){
        VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.msgUnavailableMsg)
    }
    
    @IBAction func mailBtnClick(sender: UIButton){
        if !MFMailComposeViewController.canSendMail(){
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.mailUnavailableMsg)
        } else{
            openMailComposer()
        }
    }
    
    func openMailComposer()  {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([self.contactData?.email ?? ""])
        mailComposeVC.setSubject("")
        let msgText = "Hello, \(self.contactData?.firstName ?? "")" + "\(self.contactData?.lastName ?? "")"
        mailComposeVC.setMessageBody(msgText, isHTML: false)
        present(mailComposeVC, animated: true, completion: nil)
    }
    
    @IBAction func shareConnectionBtnClick(sender: UIButton){
        let fullName = "Name: \(self.contactData?.firstName ?? "")" + "\(self.contactData?.lastName ?? "") \n"
        let jobTitle = "Job: \(self.contactData?.jobtitle ?? "") \n"
        let email = "Mail: \(self.contactData?.email ?? "")"
        let shareAll = ["\(fullName + jobTitle + email)"] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender.self
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX + sender.frame.width/2, y: self.view.bounds.minY, width: 0, height: 0)
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteConnectionBtnClick(sender: UIButton){
        let alertController = UIAlertController(title: VMCMessages.appName, message: VMCMessages.connectionDeleteMsg, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: VMCTitles.CancelBtnTitle, style: .cancel, handler: {
            alert -> Void in
        })
        let okAction = UIAlertAction(title: VMCTitles.DeleteBtnTitle, style: .destructive, handler: {
            alert -> Void in
            VMCMethods.shared.progressHudAction(hudType: "success", message: VMCMessages.connectionDeletedConfirmMsg)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editConnectionBtnClick(sender: UIButton){
        if let VC = VMCStoryboards.main.instantiateViewController(withIdentifier: VMCStoryboardID.addConnectionScreenID) as? VMCAddConnectionVC {
            VC.hidesBottomBarWhenPushed = true
            VC.isEdit = true
            VC.selectedContactData = self.contactData
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

extension VMCDetailsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         dismiss(animated: true, completion: nil)
    }
}
