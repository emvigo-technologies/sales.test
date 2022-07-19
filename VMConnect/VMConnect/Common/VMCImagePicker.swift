import UIKit
import AVFoundation

public protocol ImagePickerDelegate: AnyObject {
    func didSelectImage(image: UIImage?)
}

open class VMCImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
    }
    
    public func present(from sourceView: UIView) {
        self.presentationController?.openAlertView(title:VMCTitles.ChooseOption,
                           message: "",
                           alertStyle: .actionSheet,
                           actionTitles: [VMCTitles.PhotoLibrary, VMCTitles.Camera],
                           actionStyles: [.default, .default],
                           actions: [
                            {_ in
                                self.pickerController.allowsEditing = true
                                self.pickerController.sourceType = .photoLibrary
                                self.presentationController?.present(self.pickerController, animated: true)
                            },
                            {_ in
                                if UIImagePickerController.availableCaptureModes(for: .rear) != nil{
                                    self.pickerController.allowsEditing = false
                                    self.pickerController.sourceType = .camera
                                    self.pickerController.cameraCaptureMode = .photo
                                    self.presentationController?.present(self.pickerController, animated: true)
                                }
                                else{
                                    self.presentationController?.openAlertView(title: VMCTitles.NoCamera, message: VMCMessages.cameraUnavailableMsg, alertStyle: .alert, actionTitles: [VMCTitles.OkBtnTitle], actionStyles: [.default], actions: [{_ in }], newSourceRect: CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0))
                                }
                            }
                           ], newSourceRect: CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0))
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelectImage(image: image)
    }
}

extension VMCImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension VMCImagePicker: UINavigationControllerDelegate {
}


