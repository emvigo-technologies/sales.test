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
    
    func convertDate(fromDateFormat:String, toDateFormat:String, dateString:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = toDateFormat
        let resultString = dateFormatter.string(from: date!)
        return resultString
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

