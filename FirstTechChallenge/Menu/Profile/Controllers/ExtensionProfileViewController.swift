import Photos
// import Alamofire
// import NVActivityIndicatorView
import UIKit

extension ProfileViewController {
    // MARK: - Show no camera found

    func noCamera() {
        let alertVC = UIAlertController(title: "Alert", message: "No Camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Action to open library of photos app.

    @objc func proPicPressed(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "First Tech Challenge", message: "Please select an option to uplaod a photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { [self] _ in
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            requestPhotosPermission()
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self?.picker.sourceType = .camera
                self?.picker.cameraCaptureMode = .photo
                self?.requestCameraPermission()
            } else {
                self?.noCamera()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("User click Cancel button")
        }))
        if UIDevice.current.userInterfaceIdiom == .phone {
            alert.modalPresentationStyle = .overCurrentContext
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.frame
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Request photos permission

    func requestPhotosPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] status in
            DispatchQueue.main.async { [unowned self] in
                switch status {
                case .notDetermined, .limited: break
                case .denied, .restricted:
                    showAccessPhotos(title: "Allow access to your photos", message: "This lets you share from your camera roll and enables other features for photos and videos. Go to your settings and tap \"Photos\".")
                case .authorized:
                    self.present(self.picker, animated: true, completion: nil)
                @unknown default: break
                }
            }
        }
    }

    // MARK: - Request Camera permission

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] success in
            DispatchQueue.main.async { [unowned self] in
                switch success {
                case true:
                    self.present(self.picker, animated: true, completion: nil)
                case false:
                    self.showAccessPhotos(title: "Allow access to your camera", message: "This lets you share from your camera roll and enables other features for photos and videos. Go to your settings and tap \"Camera\".")
                }
            }
        }
    }

    // MARK: - Get the image after user has select on one to upload

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            APIHelper.shared.saveImage(image: image)
            profileHeader.profilePic.image = APIHelper.shared.getImage()
        } else if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            APIHelper.shared.saveImage(image: image)
            profileHeader.profilePic.image = APIHelper.shared.getImage()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
