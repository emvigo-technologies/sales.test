import UIKit
import SwifterSwift

class VMCAddConnectionVC: UIViewController{
    
    @IBOutlet weak var firstNameTextField: VMCTextFields!
    @IBOutlet weak var lastNameTextField: VMCTextFields!
    @IBOutlet weak var emailTextField: VMCTextFields!
    @IBOutlet weak var favColorTextField: VMCTextFields!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var bgView: UIView!
    var isEdit = false
    var selectedContactData: VMCContactModelElement?
    var imagePicker: VMCImagePicker!
    private var addConnectionVM: VMCAddConnectionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addConnectionVM = VMCAddConnectionViewModel(withDelegate: self)
        self.initalConfig()
        self.setDataInUI()
    }

    override func viewDidLayoutSubviews() {
        self.headerView.roundCorners( [.bottomLeft, .bottomRight], radius: 30.0)
    }

    func initalConfig(){
        self.bgView.layer.cornerRadius = 30
        self.bgView.addShadow(ofColor: VMCColors.ListViewShadowColor, radius: 4.0, offset: CGSize(width:0,height:0), opacity: 0.2)
        self.imagePicker = VMCImagePicker(presentationController: self, delegate: self)
    }
    
    func setDataInUI(){
        if self.isEdit{
            self.title = VMCTitles.editConnectionTitle
            if let imgUrlString = self.selectedContactData?.avatar{
                if !(imgUrlString.isEmpty){
                    self.userImage.setImage(filePath: imgUrlString, placeholderImage: UIImage(named: VMCTitles.contactImagePlaceHolder))
                }
            }
            self.firstNameTextField.text = self.selectedContactData?.firstName ?? ""
            self.lastNameTextField.text = self.selectedContactData?.lastName ?? ""
            self.emailTextField.text = self.selectedContactData?.email ?? ""
            self.favColorTextField.text = self.selectedContactData?.favouriteColor ?? ""
        }else{
            self.title = VMCTitles.addConnectionTitle
        }
    }
    
    @IBAction func cameraButtonClick(_ sender: UIButton) {
        self.imagePicker.present(from: self.view)
    }
    
    @IBAction func saveBtnClick(sender: UIButton){
        self.view.endEditing(true)
        addConnectionVM.connectionSaveApiCall(addConnectionVC: self, isEdit: self.isEdit)
    }
}

extension VMCAddConnectionVC: AddConnectionViewModelProtocol{
    func connectionSaveResponse(message: String, status: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension VMCAddConnectionVC: ImagePickerDelegate{
    func didSelectImage(image: UIImage?) {
        if let selectedImage = image {
            self.userImage.image = selectedImage.compressed(quality: 0.5)
        }
    }
}
