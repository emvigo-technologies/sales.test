import UIKit
import Foundation
import Kingfisher

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

