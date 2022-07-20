import UIKit

class VMCDetailsVC: UIViewController{
    
    @IBOutlet var bgView: UIView!
    var contactData: VMCContactModelElement?
    var titleList = ["Created","Mail","Favorite Color"]
    var mailManager: VMCMailManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.bgView.roundCorners( [.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    @IBAction func callBtnClick(sender: UIButton){
        VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.callUnavailableMsg)
    }
    
    @IBAction func messageBtnClick(sender: UIButton){
        VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.msgUnavailableMsg)
    }
    
    @IBAction func mailBtnClick(sender: UIButton){
        if let mailData = VMCMailManager(mailData: MailData(recipients:self.contactData?.email ?? "", subject: "", body: "Hello, \(self.contactData?.firstName ?? "")" + "\(self.contactData?.lastName ?? "")")){
            self.mailManager = mailData
            mailManager?.send(on: self, completion: { result in
                switch result{
                case .failure(let error):
                     print(error.localizedDescription)
                     self.dismiss(animated: true, completion: nil)
                     break
                case .success(let mailResult):
                    print(mailResult)
                    self.dismiss(animated: true, completion: nil)
                    break
                }
                self.mailManager = nil
            })
        }
        else{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.mailUnavailableMsg)
        }
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
        self.openAlertView(title: VMCMessages.appName,
                           message: VMCMessages.connectionDeleteMsg,
                           alertStyle: .alert,
                           actionTitles: [VMCTitles.cancelBtnTitle, VMCTitles.deleteBtnTitle],
                           actionStyles: [.cancel, .destructive],
                           actions: [
                            {_ in
                            },
                            {_ in
                                VMCMethods.shared.progressHudAction(hudType: "success", message: VMCMessages.connectionDeletedConfirmMsg)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                           ], newSourceRect: sender.bounds)
        
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

extension VMCDetailsVC: UITableViewDelegate,UITableViewDataSource {
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
}
