//
//  DetailsVC.swift
//  Nanit_ex
//
//  Created by Iris Ronen on 11/7/21.
//

import UIKit

class DetailsVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var showBirthdayButton: UIButton!
    
    //MARK: Properties
    private let showBirthdayIdentifier = "show_birthday_screen"
    
    private var imagePicker = UIImagePickerController()
    
    private var isShowButtonOn: Bool {
        return !(nameTextField.text?.isEmpty ?? true) && pictureImageView.image != nil
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdayDatePicker.datePickerMode = .date
        var minimumDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: minimumDate!)
        birthdayDatePicker.minimumDate = minimumDate
        birthdayDatePicker.maximumDate = Date()
        birthdayDatePicker.addTarget(self, action: #selector(birthdateChanged(_:)), for: .valueChanged)
        
        if let date = UserDefaultsUtil().getBirthdate() {
            birthdayDatePicker.date = date
        }
        
        nameTextField.delegate = self
        nameTextField.text = UserDefaultsUtil().getName() ?? ""
        
        imagePicker.delegate = self
        pictureImageView.image = UserDefaultsUtil().getPicture() ?? UIImage()
        pictureImageView.layer.borderWidth = 1
        pictureImageView.layer.borderColor = UIColor.gray.cgColor
        
        showBirthdayButton.titleLabel?.minimumScaleFactor = 0.5
        showBirthdayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        setShowBirthdayButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Actions
    @objc func birthdateChanged(_ sender: UIDatePicker) {
        UserDefaultsUtil().saveBirthdate(sender.date)
        setShowBirthdayButtonState()
    }
    
    @IBAction func showBirthdayScreenPressed(_ sender: UIButton) {
        print("showBirthdayScreenPressed")
        performSegue(withIdentifier: showBirthdayIdentifier, sender: self)
    }
    
    private func setShowBirthdayButtonState() {
        print("isShowButtonOn=\(isShowButtonOn)")
        showBirthdayButton.alpha = isShowButtonOn ? 1 : 0.5
        showBirthdayButton.isUserInteractionEnabled = isShowButtonOn
    }
    

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? ShowBirthdayVC {
            print("Prepare for segue")
            vc.name = nameTextField.text
            vc.birthDate = birthdayDatePicker.date
            vc.picture = pictureImageView.image
        }
    }

    // MARK: UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        closeNameTextField()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        closeNameTextField()
    }
    
    private func closeNameTextField() {
        print("nameTextFieldIsNotInFocus")
        nameTextField.resignFirstResponder()
        if let name = nameTextField.text {
            if !name.isEmpty {
                UserDefaultsUtil().saveName(name)
            }
        }
        setShowBirthdayButtonState()
    }
    
    // MARK: UIImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            pictureImageView.image = pickedImage
            pictureImageView.contentMode = .scaleAspectFit
            UserDefaultsUtil().savePicture(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAPicturePressed(_ sender: UIButton) {
        print("pickAPicturePressed")
        closeNameTextField()
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
            
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = pictureImageView
            alert.popoverPresentationController?.sourceRect = pictureImageView.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
       default:
            break
       }
        
       present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
       }
   }

    private func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
   }
}

