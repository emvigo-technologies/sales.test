import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = self.window
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaults.standard.bool(forKey: "isLogged"){
            if let homeTab = storyboard.instantiateViewController(withIdentifier: "VMCHomeTab") as? UITabBarController{
                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = homeTab
            }
        }else{
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "VMCLoginVC") as? VMCLoginVC{
                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = loginVC
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

