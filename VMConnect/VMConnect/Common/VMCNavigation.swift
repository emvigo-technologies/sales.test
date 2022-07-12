import UIKit

class VMCNavigation: UINavigationController {

    let navigationAppearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationAppearance.configureWithDefaultBackground()
        navigationAppearance.backgroundColor = UIColor.white
        navigationAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: VMCColors.GenericRedColor, NSAttributedString.Key.font: VMCFonts.Futura.medium(20)]
        navigationBar.tintColor = .black
        navigationBar.standardAppearance = navigationAppearance
        navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationBar.compactAppearance = navigationAppearance
    }
}
