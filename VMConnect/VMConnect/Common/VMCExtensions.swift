import UIKit
import Foundation
import Kingfisher

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

public extension UIImageView{
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

public extension UIViewController{
     func openAlertView(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                              actions: [((UIAlertAction) -> Void)], newSourceRect: CGRect){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = newSourceRect
            popoverPresentationController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true)
    }
}
