import UIKit
import Alamofire
import Kingfisher
import DZNEmptyDataSet

class VMCRoomsVC: UIViewController{
   
    @IBOutlet var tblView: UITableView!
    @IBOutlet var occupancyCountLbl: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var roomsList: [VMCRoomsModelElement] = []
    var filterRoomsList: [VMCRoomsModelElement] = []
    var refreshControl = UIRefreshControl()
    private var roomsVM: VMCRoomsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roomsVM = VMCRoomsViewModel(withDelegate: self)
        self.initialConfig()
        //MARK: Get Rooms List
        self.roomsVM.fetchRooms()
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
        self.roomsVM.fetchRooms()
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.updateListOnSegmentChange()
    }
    
    func updateListOnSegmentChange(){
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.filterRoomsList = self.roomsList.filter({$0.isOccupied == true})
            self.occupancyCountLbl.text = VMCUIKeys.occupied + " (\(self.filterRoomsList.count))"
            break;
        case 1:
            self.filterRoomsList = self.roomsList.filter({$0.isOccupied == false})
            self.occupancyCountLbl.text = VMCUIKeys.unoccupied + " (\(self.filterRoomsList.count))"
            break;
        default:
            break;
        }
        self.tblView.reloadData()
    }
}

extension VMCRoomsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterRoomsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VMCTableViewCells.cell, for: indexPath) as! VMCRoomsTVCell
        cell.selectionStyle = .none
        cell.roomNameLabel.text = VMCUIKeys.room + " \(indexPath.row + 1)"
        cell.occupancyCountLabel.attributedText = VMCMethods.shared.multiFontString(firstText: VMCUIKeys.maxOccupancy, firstFont: VMCFonts.GilliSans.regular(14), firstColor: VMCColors.PlaceHolderTextColor, secondText: "\(self.filterRoomsList[indexPath.row].maxOccupancy ?? 0)", secondFont: VMCFonts.GilliSans.regular(14), secondColor:UIColor.black)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VMCRoomsVC: RoomsViewModelProtocol{
    func roomsListResponse(message: String, status: Bool, response: [VMCRoomsModelElement]) {
        self.roomsList = response
        self.updateListOnSegmentChange()
    }
}

extension VMCRoomsVC: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let MyString = [NSAttributedString.Key.font : VMCFonts.Helvetica.regular(18), NSAttributedString.Key.foregroundColor : VMCColors.PlaceHolderTextColor]
        let attributedString = NSMutableAttributedString(string:VMCMessages.roomListEmptyMsg, attributes:MyString)
        return attributedString
    }
}
