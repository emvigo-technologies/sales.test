import UIKit
import SVProgressHUD

class VMCLoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: VMCTextFields!
    @IBOutlet weak var passwordTextField: VMCTextFields!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInBtnClick(_ sender: UIButton) {
        if self.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            SVProgressHUD.showInfo(withStatus: VMCMessages.invalidEmailMsg)
            self.emailTextField.becomeFirstResponder()
        }else if !VMCMethods.shared.isValidEmail(emailText: self.emailTextField.text!){
            SVProgressHUD.showInfo(withStatus: VMCMessages.invalidEmailMsg)
            self.emailTextField.becomeFirstResponder()
        }else if self.passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            SVProgressHUD.showInfo(withStatus: VMCMessages.passwordEmptyMsg)
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            SVProgressHUD.showSuccess(withStatus: VMCMessages.loginSuccessMsg)
            UserDefaults.standard.set(true, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let homeTab = VMCStoryboards.main.instantiateViewController(withIdentifier: VMCStoryboardID.hometabBarNavigationID) as? UITabBarController{
                    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                    sceneDelegate.window?.rootViewController = homeTab
                }
            }
        }
    }
}
