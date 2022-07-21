import Foundation
import IQKeyboardManagerSwift
import SVProgressHUD

class VMCConfig: NSObject {
    static let shared = VMCConfig()
    
    func appInitialSetUp(){
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = VMCColors.TabBarColor
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30
        IQKeyboardManager.shared.toolbarTintColor = .black
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setMinimumDismissTimeInterval(0.6)
        SVProgressHUD.setForegroundColor(VMCColors.GenericRedColor)
        SVProgressHUD.setBackgroundColor(VMCColors.BGColor)
    }
}
