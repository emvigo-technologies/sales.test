import UIKit
import Kingfisher
import DZNEmptyDataSet

class VMCContactsVC: UIViewController{

    @IBOutlet var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var connectionsCountLbl: UILabel!
    var contactsList: [VMCContactModelElement] = []
    var filterContactsList: [VMCContactModelElement] = []
    var refreshControl = UIRefreshControl()
    var searchText = String()
    var isSearch = false
    private var contactsVM: VMCContactsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactsVM = VMCContactsViewModel(withDelegate: self)
        self.initialConfig()
        
        //MARK: Get Contact List
        self.contactsVM.fetchContacts()
        // Do any additional setup after loading the view.
    }
    
    func initialConfig(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshContactList), for: .valueChanged)
        tblView.addSubview(refreshControl)
        self.tblView.emptyDataSetDelegate = self
        self.tblView.emptyDataSetSource = self
    }
    
    @objc func refreshContactList(sender:UIRefreshControl) {
        self.refreshControl.endRefreshing()
        self.contactsVM.fetchContacts()
    }
    
    @IBAction func logOutBtnClick(sender: UIButton){
        DispatchQueue.main.async {
            self.openAlertView(title: VMCTitles.logoutTitle,
                               message: VMCMessages.logOutMsg,
                               alertStyle: .actionSheet,
                               actionTitles: [VMCTitles.logoutTitle,  VMCTitles.cancelBtnTitle],
                               actionStyles: [.destructive, .cancel],
                               actions: [
                                {_ in
                                    UserDefaults.standard.set(false, forKey: "isLogged")
                                    UserDefaults.standard.synchronize()
                                    if let loginVC = VMCStoryboards.main.instantiateViewController(withIdentifier: VMCStoryboardID.loginScreenID) as? VMCLoginVC{
                                        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                                        sceneDelegate.window?.rootViewController = loginVC
                                    }
                                },
                                {_ in
                                }
                               ], newSourceRect: sender.bounds)
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

extension VMCContactsVC: ContactsViewModelProtocol{
    func contactListResponse(message: String, status: Bool, response: [VMCContactModelElement]) {
        self.contactsList = response
        self.connectionsCountLbl.text = "Connections (\(self.contactsList.count))"
        self.tblView.reloadData()
    }
}

extension VMCContactsVC: UITableViewDelegate, UITableViewDataSource{
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
                cell.profileImage.setImage(filePath: imgUrlString, placeholderImage: UIImage(named: VMCTitles.contactImagePlaceHolder))
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
}

extension VMCContactsVC: UISearchBarDelegate, UISearchDisplayDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard (searchBar.text?.count ?? 0) > 1 else{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.searchValidationMsg)
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
            self.isSearch = false
            self.connectionsCountLbl.text = "Connections (\(self.contactsList.count))"
            self.tblView.reloadData()
        }else{
            if searchText.count > 1{
                self.searchText = searchBar.text ?? ""
                self.isSearch = true
                self.updateSearchResults(searchString: self.searchText)
            }
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
