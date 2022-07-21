import UIKit

class VMCDetailHeaderTVCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.borderWidth = 1.0
        self.userImageView.layer.borderColor = UIColor.white.cgColor
        self.bgView.addShadow(ofColor: VMCColors.ListViewShadowColor, radius: 4.0, offset: CGSize(width:0,height:0), opacity: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
