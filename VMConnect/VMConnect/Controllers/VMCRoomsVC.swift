import UIKit
import Alamofire
import Kingfisher
import DZNEmptyDataSet

class VMCRoomsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var occupancyCountLbl: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var roomsList: [VMCRoomsModelElement] = []
    var filterRoomsList: [VMCRoomsModelElement] = []
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshContactList), for: .valueChanged)
        tblView.addSubview(refreshControl)
        self.tblView.emptyDataSetDelegate = self
        self.tblView.emptyDataSetSource = self
        self.getRoomsList()
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshContactList(sender:UIRefreshControl) {
        self.refreshControl.endRefreshing()
        self.getRoomsList()
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.filterRoomsList = self.roomsList.filter({$0.isOccupied == true})
            self.occupancyCountLbl.text = "Occupied (\(self.filterRoomsList.count))"
            break;
        case 1:
            self.filterRoomsList = self.roomsList.filter({$0.isOccupied == false})
            self.occupancyCountLbl.text = "Unoccupied (\(self.filterRoomsList.count))"
            break;
        default:
            break;
        }
        self.tblView.reloadData()
    }
    
    //MARKS:GET ROOMS LIST
    func getRoomsList(){
        VMCMethods.shared.progressHudAction(hudType: "show", message: "")
        VMCApiManager.getRoomsData(completion: { message, success, data in
            if success{
                VMCMethods.shared.progressHudAction(hudType: "dismiss", message: "")
                self.roomsList = data ?? []
                switch self.segmentedControl.selectedSegmentIndex {
                case 0:
                    self.filterRoomsList = data?.filter({$0.isOccupied == true}) ?? []
                    self.occupancyCountLbl.text = "Occupied (\(self.filterRoomsList.count))"
                    break;
                case 1:
                    self.filterRoomsList = data?.filter({$0.isOccupied == false}) ?? []
                    self.occupancyCountLbl.text = "Unoccupied (\(self.filterRoomsList.count))"
                    break;
                default:
                    break;
                }
                self.tblView.reloadData()
            }else{
                VMCMethods.shared.progressHudAction(hudType: "error", message: message ?? "")
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterRoomsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VMCRoomsTVCell
        cell.selectionStyle = .none
        cell.roomNameLabel.text = "Room \(indexPath.row + 1)"
        cell.occupancyCountLabel.attributedText = VMCMethods.shared.multiFontString(firstText: "Max.Occupancy:  ", firstFont: VMCFonts.GilliSans.regular(14), firstColor: VMCColors.PlaceHolderTextColor, secondText: "\(self.filterRoomsList[indexPath.row].maxOccupancy ?? 0)", secondFont: VMCFonts.GilliSans.regular(14), secondColor:UIColor.black)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension VMCRoomsVC: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let MyString = [NSAttributedString.Key.font : VMCFonts.Helvetica.regular(18), NSAttributedString.Key.foregroundColor : VMCColors.PlaceHolderTextColor]
        let attributedString = NSMutableAttributedString(string:VMCMessages.roomListEmptyMsg, attributes:MyString)
        return attributedString
    }
}
