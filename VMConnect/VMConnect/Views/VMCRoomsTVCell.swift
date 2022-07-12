import UIKit

class VMCRoomsTVCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var occupancyCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.addShadow(ofColor: VMCColors.ListViewShadowColor, radius: 4.0, offset: CGSize(width:0,height:0), opacity: 0.2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
