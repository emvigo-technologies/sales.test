import Foundation

protocol LoginViewModelProtocol {
    func loginResponse(message:String,status:Bool)
}

class VMCLoginViewModel: NSObject{
    
    var delegate:LoginViewModelProtocol?

    init(withDelegate delegate:LoginViewModelProtocol) {
        super.init()
        self.delegate = delegate
    }
    
    func loginApiCall(loginVC: VMCLoginVC?){
        if loginVC!.emailTextField!.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.info, message: VMCMessages.invalidEmailMsg)
            loginVC?.emailTextField.becomeFirstResponder()
        }else if !VMCMethods.shared.isValidEmail(emailText: loginVC!.emailTextField?.text! ?? ""){
            VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.info, message: VMCMessages.invalidEmailMsg)
            loginVC?.emailTextField.becomeFirstResponder()
        }else if loginVC!.passwordTextField!.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.info, message: VMCMessages.passwordEmptyMsg)
            loginVC?.passwordTextField.becomeFirstResponder()
        } else {
            VMCMethods.shared.progressHudAction(hudType: VMCHUDStatus.success, message: VMCMessages.loginSuccessMsg)
            UserDefaults.standard.set(true, forKey: VMCUserDefaultKeys.loginStatus)
            UserDefaults.standard.synchronize()
            self.delegate?.loginResponse(message: "",status: true)
        }
    }
}


