import UIKit
import SVProgressHUD
import SwifterSwift

class VMCAddConnectionVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: VMCTextFields!
    @IBOutlet weak var lastNameTextField: VMCTextFields!
    @IBOutlet weak var emailTextField: VMCTextFields!
    @IBOutlet weak var favColorTextField: VMCTextFields!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var bgView: UIView!
    let imagePicker = UIImagePickerController()
    var isEdit = false
    var selectedContactData: VMCContactModelElement?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.layer.cornerRadius = 30
        self.bgView.addShadow(ofColor: VMCColors.ListViewShadowColor, radius: 4.0, offset: CGSize(width:0,height:0), opacity: 0.2)
        self.imagePicker.delegate = self
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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.headerView.roundCorners( [.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    @IBAction func cameraButtonClick(_ sender: UIButton) {
        let alertController = UIAlertController(title: VMCTitles.ChooseOption, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let libAction = UIAlertAction(title: VMCTitles.PhotoLibrary, style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraAction = UIAlertAction(title: VMCTitles.Camera, style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil{
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else{
                self.noCamera()
            }
        })
        let cancelAction = UIAlertAction(title: VMCTitles.CancelBtnTitle, style: UIAlertAction.Style.cancel, handler: {
            alert -> Void in
        })
        alertController.addAction(libAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage{
            self.userImage.image = pickedImage.compressed(quality: 0.5)
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: VMCTitles.NoCamera,
            message: VMCMessages.cameraUnavailableMsg,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: VMCTitles.OkBtnTitle,style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    @IBAction func saveBtnClick(sender: UIButton){
        if self.firstNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            SVProgressHUD.showInfo(withStatus: VMCMessages.firstNameEmptyMsg)
            self.firstNameTextField.becomeFirstResponder()
        }else if self.lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            SVProgressHUD.showInfo(withStatus: VMCMessages.lastNameEmptyMsg)
            self.lastNameTextField.becomeFirstResponder()
        }else if self.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            SVProgressHUD.showInfo(withStatus: VMCMessages.invalidEmailMsg)
            self.emailTextField.becomeFirstResponder()
        }else if !VMCMethods.shared.isValidEmail(emailText: self.emailTextField.text!){
            SVProgressHUD.showInfo(withStatus: VMCMessages.invalidEmailMsg)
            self.emailTextField.becomeFirstResponder()
        }else if self.favColorTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            SVProgressHUD.showInfo(withStatus: VMCMessages.favColorEmptyMsg)
            self.favColorTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            SVProgressHUD.showSuccess(withStatus: self.isEdit ? VMCMessages.connectionUpdatedMsg : VMCMessages.newConnectionAddedMsg)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
