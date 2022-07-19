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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.layer.cornerRadius = 30
        self.bgView.addShadow(ofColor: VMCColors.ListViewShadowColor, radius: 4.0, offset: CGSize(width:0,height:0), opacity: 0.2)
        self.imagePicker = VMCImagePicker(presentationController: self, delegate: self)
        self.setDataInUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.headerView.roundCorners( [.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    func setDataInUI(){
        if self.isEdit{
            self.title = VMCTitles.EditConnectionTitle
            if let imgUrlString = self.selectedContactData?.avatar{
                if !(imgUrlString.isEmpty){
                    self.userImage.setImage(filePath: imgUrlString, placeholderImage: UIImage(named: VMCTitles.ContactImagePlaceHolder))
                }
            }
            self.firstNameTextField.text = self.selectedContactData?.firstName ?? ""
            self.lastNameTextField.text = self.selectedContactData?.lastName ?? ""
            self.emailTextField.text = self.selectedContactData?.email ?? ""
            self.favColorTextField.text = self.selectedContactData?.favouriteColor ?? ""
        }else{
            self.title = VMCTitles.AddConnectionTitle
        }
    }
    
    @IBAction func cameraButtonClick(_ sender: UIButton) {
        self.imagePicker.present(from: self.view)
    }
    
    @IBAction func saveBtnClick(sender: UIButton){
        if self.firstNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.firstNameEmptyMsg)
            self.firstNameTextField.becomeFirstResponder()
        }else if self.lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.lastNameEmptyMsg)
            self.lastNameTextField.becomeFirstResponder()
        }else if self.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.invalidEmailMsg)
            self.emailTextField.becomeFirstResponder()
        }else if !VMCMethods.shared.isValidEmail(emailText: self.emailTextField.text!){
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.invalidEmailMsg)
            self.emailTextField.becomeFirstResponder()
        }else if self.favColorTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.favColorEmptyMsg)
            self.favColorTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            VMCMethods.shared.progressHudAction(hudType: "success", message: self.isEdit ? VMCMessages.connectionUpdatedMsg : VMCMessages.newConnectionAddedMsg)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
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
