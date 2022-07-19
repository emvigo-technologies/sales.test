import Foundation
import UIKit

class VMCConstants: NSObject {
}

//MARK: MESSAGES
struct VMCMessages {
    static let appName  = "VMConnects"
    static let invalidEmailMsg = "Please enter valid email"
    static let passwordEmptyMsg = "Please enter your password"
    static let loginSuccessMsg = "Login Success"
    static let logOutMsg = "Do you want to log out from VMConnects?"
    static let searchValidationMsg = "Please enter at least 2 characters"
    static let callUnavailableMsg = "Call unavailable"
    static let mailUnavailableMsg = "Mail service unavailable"
    static let msgUnavailableMsg = "Message unavailable"
    static let connectionDeleteMsg = "Are you sure, you want to delete this connection?"
    static let newConnectionAddedMsg = "Connection successfully added"
    static let connectionUpdatedMsg = "Connection successfully updated"
    static let connectionDeletedConfirmMsg = "Connection successfully deleted"
    static let firstNameEmptyMsg = "Please enter your first name"
    static let lastNameEmptyMsg = "Please enter your last name"
    static let favColorEmptyMsg = "Please enter your favorite color"
    static let cameraUnavailableMsg = "Sorry, this device has no camera"
    static let roomListEmptyMsg = "Rooms list is empty"
    static let connectionListEmptyMsg = "Connection list is empty"
    static let searchResultEmptyMsg = "No results found"
    static let cameraAccessMsg = "Enable camera access to VMConnect, so you can update the profile picture."
}

struct VMCTitles {
    static let LogoutTitle  = "Log Out"
    static let CancelBtnTitle = "Cancel"
    static let DeleteBtnTitle = "Delete"
    static let AddConnectionTitle = "Add Connection"
    static let EditConnectionTitle = "Edit Connection"
    static let ContactImagePlaceHolder = "contactPlaceHolder"
    static let ChooseOption = "Choose Option"
    static let PhotoLibrary = "Photo Library"
    static let Camera = "Camera"
    static let NoCamera = "No Camera"
    static let OkBtnTitle = "OK"
    static let CameraAccess = "Turn on Camera Access"
    static let openSettings = "Open Settings"
   
}

//MARK: COLORS
struct VMCColors {
    static let GenericRedColor = UIColor(red:196.0/255.0, green:2.0/255.0, blue:2.0/255.0, alpha:1.00)
    static let BGColor = UIColor(red:227.0/255.0, green:227.0/255.0, blue:227.0/255.0, alpha:1.00)
    static let TabBarColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1.00)
    static let PlaceHolderTextColor = UIColor(red:114.0/255.0, green:114.0/255.0, blue:114.0/255.0, alpha:1.00)
    static let ListViewShadowColor = UIColor.lightGray
}

//MARK: FONTS
struct VMCFonts {
    struct Helvetica{
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont.init(name: "Helvetica", size: size)!
        }
        static func light(_ size: CGFloat) -> UIFont {
            return UIFont.init(name: "Helvetica-Light", size: size)!
        }
        static func Bold(_ size: CGFloat) -> UIFont {
            return UIFont.init(name: "Helvetica-Bold", size: size)!
        }
    }
    struct GilliSans{
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont.init(name: "GillSans", size: size)!
        }
        static func Bold(_ size: CGFloat) -> UIFont {
            return UIFont.init(name: "GillSans-Bold", size: size)!
        }
    }
    struct Futura{
        static func medium(_ size: CGFloat) -> UIFont {
            return UIFont.init(name: "Futura-Medium", size: size)!
        }
    }
}
