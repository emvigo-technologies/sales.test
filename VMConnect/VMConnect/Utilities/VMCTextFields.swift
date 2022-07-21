import Foundation
import UIKit

class VMCTextFields: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textColor = VMCColors.GenericRedColor
        self.font = VMCFonts.Futura.medium(15.0)
    }
}
