import UIKit
import Foundation
import Kingfisher
import SVProgressHUD

class VMCMethods: NSObject {
    static let shared = VMCMethods()
    
    func isValidEmail(emailText: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailText)
    }
    
    func multiFontString(firstText:String, firstFont: UIFont = VMCFonts.GilliSans.regular(14), firstColor: UIColor = UIColor.lightGray, secondText:String, secondFont:UIFont = VMCFonts.GilliSans.Bold(14), secondColor: UIColor = UIColor.black) -> NSAttributedString {
        
        let MyString1 = [NSAttributedString.Key.font : firstFont, NSAttributedString.Key.foregroundColor : firstColor]
        let MyString2 = [NSAttributedString.Key.font : secondFont, NSAttributedString.Key.foregroundColor : secondColor]
        
        let attributedString1 = NSMutableAttributedString(string:firstText, attributes:MyString1)
        let attributedString2 = NSMutableAttributedString(string:secondText, attributes:MyString2)
        
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
    
    func progressHudAction(hudType:String,message:String){
        switch hudType {
        case "show":
            SVProgressHUD.show()
            break
        case "dismiss":
            SVProgressHUD.dismiss()
            break
        case "error":
            SVProgressHUD.showError(withStatus: message)
            break
        case "info":
            SVProgressHUD.showInfo(withStatus: message)
            break
        case "success":
            SVProgressHUD.showSuccess(withStatus: message)
            break
        default:
            break
        }
    }

}

public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}

extension UIImageView{
    func setImage(filePath: String?, placeholderImage:UIImage?){
        guard let urlString = filePath else{
            self.image = placeholderImage
            return
        }
        guard let url = URL(string: urlString) else{
            self.image = placeholderImage
            return
        }
        self.kf.setImage(with: url, placeholder: placeholderImage, options: [.transition(.fade(0.2))])
    }
}

extension UIViewController{
    public func openAlertView(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                              actions: [((UIAlertAction) -> Void)], senderType:UIControl){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = senderType.bounds
        }
        self.present(alertController, animated: true)
    }
}
