import UIKit
import PhotosUI

extension MyEditVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.myProfileImage.image = (image as? UIImage) ?? UIImage(named: "NoneProfile")
                    self.newImage.accept((image as? UIImage) ?? UIImage(named: "NoneProfile"))
                }
            }
        }
    }
}
