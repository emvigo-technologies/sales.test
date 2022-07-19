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
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            if type == .camera {
                self.checkCameraPermission()
            }
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
       
        let alertController = UIAlertController(title: VMCTitles.ChooseOption, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .photoLibrary, title: VMCTitles.PhotoLibrary)
        {
            alertController.addAction(action)
        }
        if let action = self.action(for: .camera, title: VMCTitles.Camera)
        {
            alertController.addAction(action)
        }
       
        alertController.addAction(UIAlertAction(title: VMCTitles.CancelBtnTitle, style: .cancel, handler: nil))
    
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelectImage(image: image)
    }
}

extension VMCImagePicker {
    func checkCameraPermission() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .denied:
            let alert = UIAlertController.init(title: VMCTitles.CameraAccess, message: VMCMessages.cameraAccessMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: VMCTitles.CancelBtnTitle, style: .cancel, handler: { (_) in
            }))
            alert.addAction(UIAlertAction.init(title: VMCTitles.openSettings, style: .default, handler: { (_) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            }))
            self.presentationController?.present(alert, animated: true, completion: nil)
        default:
            break
        }
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


