import Foundation

protocol AddConnectionViewModelProtocol {
    func connectionSaveResponse(message:String,status:Bool)
}

class VMCAddConnectionViewModel: NSObject{
    
    var delegate:AddConnectionViewModelProtocol?

    init(withDelegate delegate:AddConnectionViewModelProtocol) {
        super.init()
        self.delegate = delegate
    }
    
    func connectionSaveApiCall(addConnectionVC: VMCAddConnectionVC?, isEdit: Bool){
        if addConnectionVC!.firstNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.firstNameEmptyMsg)
            addConnectionVC!.firstNameTextField.becomeFirstResponder()
        }else if addConnectionVC!.lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.lastNameEmptyMsg)
            addConnectionVC!.lastNameTextField.becomeFirstResponder()
        }else if addConnectionVC!.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.invalidEmailMsg)
            addConnectionVC!.emailTextField.becomeFirstResponder()
        }else if !VMCMethods.shared.isValidEmail(emailText: addConnectionVC!.emailTextField.text!){
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.invalidEmailMsg)
            addConnectionVC!.emailTextField.becomeFirstResponder()
        }else if addConnectionVC!.favColorTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: "info", message: VMCMessages.favColorEmptyMsg)
            addConnectionVC!.favColorTextField.becomeFirstResponder()
        } else {
            VMCMethods.shared.progressHudAction(hudType: "success", message: isEdit ? VMCMessages.connectionUpdatedMsg : VMCMessages.newConnectionAddedMsg)
            self.delegate?.connectionSaveResponse(message: "", status: true)
        }
    }
}
