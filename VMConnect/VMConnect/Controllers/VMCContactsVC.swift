import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher
import DZNEmptyDataSet

class VMCContactsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var connectionsCountLbl: UILabel!
    var contactsList: [VMCContactModelElement] = []
    var filterContactsList: [VMCContactModelElement] = []
    var refreshControl = UIRefreshControl()
    var searchText = String()
    var isSearch = false
    
    struct Section {
        let letter : String
        let names : [VMCContactModelElement] = []
    }
    
    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshContactList), for: .valueChanged)
        tblView.addSubview(refreshControl)
        self.tblView.emptyDataSetDelegate = self
        self.tblView.emptyDataSetSource = self
        self.getContacts()
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshContactList(sender:UIRefreshControl) {
        self.refreshControl.endRefreshing()
        self.getContacts()
    }
    
    //MARKS:GET CONTACTS LIST
    func getContacts(){
        SVProgressHUD.show()
        VMCApiManager.getContactsData(completion: { message, success, data in
            if success{
                SVProgressHUD.dismiss()
                self.contactsList = data ?? []
                //Contact List Sorting
                self.contactsList = self.contactsList.sorted(by: { (Obj1, Obj2) -> Bool in
                    let Obj1_Name = Obj1.firstName ?? ""
                    let Obj2_Name = Obj2.firstName ?? ""
                    return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                })
                self.connectionsCountLbl.text = "Connections (\(self.contactsList.count))"
                self.tblView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: message)
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearch ? self.filterContactsList.count : self.contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VMCMyConnectionsTVCell
        cell.selectionStyle = .none
        cell.nameLabel.text = self.isSearch ? "\(self.filterContactsList[indexPath.row].firstName ?? "") " + "\(self.filterContactsList[indexPath.row].lastName ?? "")" : "\(self.contactsList[indexPath.row].firstName ?? "") " + "\(self.contactsList[indexPath.row].lastName ?? "")"
        cell.jobLabel.text = self.isSearch ? self.filterContactsList[indexPath.row].jobtitle ?? "" : self.contactsList[indexPath.row].jobtitle ?? ""
        if let imgUrlString = self.isSearch ? self.filterContactsList[indexPath.row].avatar : self.contactsList[indexPath.row].avatar{
            if !(imgUrlString.isEmpty){
                cell.profileImage.setImage(filePath: imgUrlString, placeholderImage: UIImage(named: VMCTitles.ContactImagePlaceHolder))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let VC =  VMCStoryboards.main.instantiateViewController(withIdentifier: VMCStoryboardID.connectionDetailScreenID) as? VMCDetailsVC {
            VC.hidesBottomBarWhenPushed = true
            VC.contactData = self.isSearch ? self.filterContactsList[indexPath.row] : self.contactsList[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func logOutBtnClick(sender: UIButton){
        DispatchQueue.main.async {
            let sheet = UIAlertController(title: VMCTitles.LogoutTitle, message: VMCMessages.logOutMsg, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: VMCTitles.LogoutTitle, style: .destructive, handler: { (action) in
                UserDefaults.standard.set(false, forKey: "isLogged")
                UserDefaults.standard.synchronize()
                if let loginVC = VMCStoryboards.main.instantiateViewController(withIdentifier: VMCStoryboardID.loginScreenID) as? VMCLoginVC{
                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    sceneDelegate.window?.rootViewController = loginVC
                }
            }))
            sheet.addAction(UIAlertAction(title: VMCTitles.CancelBtnTitle, style: .cancel, handler: { (action) in
                sheet.dismiss(animated: true, completion: nil)
            }))
            if let popoverPresentationController = sheet.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = sender.bounds
            }
            self.present(sheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func addConnectionBtnClick(sender: UIButton){
        if let VC =  VMCStoryboards.main.instantiateViewController(withIdentifier: VMCStoryboardID.addConnectionScreenID) as? VMCAddConnectionVC {
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }

    func updateSearchResults(searchString:String) {
        if searchString != "", searchString.count > 0{
            let filterData = self.contactsList.filter{
                return "\($0.firstName ?? "")\($0.lastName ?? "")".range(of: searchString, options: .caseInsensitive) != nil
            }
            self.filterContactsList = filterData
            self.connectionsCountLbl.text = "Connections (\(self.filterContactsList.count))"
            self.tblView.reloadData()
        }
    }
}

extension VMCContactsVC: UISearchBarDelegate, UISearchDisplayDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard (searchBar.text?.count ?? 0) > 1 else{
            SVProgressHUD.showInfo(withStatus: VMCMessages.searchValidationMsg)
            return
        }
        self.searchText = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        self.isSearch = true
        self.updateSearchResults(searchString: self.searchText)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            self.searchText = ""
            self.searchBar.resignFirstResponder()
            self.isSearch = false
            self.connectionsCountLbl.text = "Connections (\(self.contactsList.count))"
            self.tblView.reloadData()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text ?? ""
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchText = ""
        self.searchBar.resignFirstResponder()
        self.isSearch = false
        self.connectionsCountLbl.text = "Connections (\(self.contactsList.count))"
        self.tblView.reloadData()
    }
}

extension VMCContactsVC: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let MyString = [NSAttributedString.Key.font : VMCFonts.Helvetica.regular(18), NSAttributedString.Key.foregroundColor : VMCColors.PlaceHolderTextColor]
        let attributedString = NSMutableAttributedString(string:self.isSearch ? VMCMessages.searchResultEmptyMsg : VMCMessages.connectionListEmptyMsg, attributes:MyString)
        return attributedString
    }
}
