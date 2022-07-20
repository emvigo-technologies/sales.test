import UIKit

class VMCLoginVC: UIViewController {

    @IBOutlet weak var emailTextField: VMCTextFields!
    @IBOutlet weak var passwordTextField: VMCTextFields!
    private var loginVM: VMCLoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginVM = VMCLoginViewModel(withDelegate: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        loginVM.loginApiCall(loginVC: self)
    }
}

extension VMCLoginVC: LoginViewModelProtocol{
    func loginResponse(message:String,status:Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let homeTab = VMCStoryboards.main.instantiateViewController(withIdentifier: VMCStoryboardID.hometabBarNavigationID) as? UITabBarController{
                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = homeTab
            }
        }
    }
}
