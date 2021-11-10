//
//  ShowBirthdayVC.swift
//  Nanit_ex
//
//  Created by Iris Ronen on 11/9/21.
//

import UIKit

class ShowBirthdayVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var babyView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var leftSwirls: UIImageView!
    @IBOutlet weak var rightSwirls: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var babyImageView: UIImageView!
    @IBOutlet weak var babyPlaceHolderImageView: UIImageView!
    @IBOutlet weak var nanitLogoImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    // MARK: Properties
    var name: String?
    var birthDate: Date?
    weak var picture: UIImage?
    
    private var imagePicker = UIImagePickerController()
    private let cameraButton = UIButton()
    
    private var mainTheme = MainTheme.Elephant
    
    private var babyAgeNumber: Int?
    
    private let backgroundColors: [MainTheme : UIColor]  = [
        MainTheme.Fox : .paleTeal,
        MainTheme.Elephant : .pale,
        MainTheme.Pelican : .lightBlueGrey
    ]
    
    private let backgroundImages: [MainTheme : UIImage] = [
        MainTheme.Fox : UIImage(named: "iOsBgFox")!,
        MainTheme.Elephant : UIImage(named: "iOsBgElephant")!,
        MainTheme.Pelican : UIImage(named: "iOsBgPelican")!,
    ]
    
    private let babyPlaceHolderImages: [MainTheme : UIImage]  = [
        MainTheme.Fox : UIImage(named: "defaultPlaceHolderGreen")!,
        MainTheme.Elephant : UIImage(named: "defaultPlaceHolderYellow")!,
        MainTheme.Pelican : UIImage(named: "defaultPlaceHolderBlue")!,
    ]
    
    private let cameraImages: [MainTheme : UIImage]  = [
        MainTheme.Fox : UIImage(named: "cameraIconGreen")!,
        MainTheme.Elephant : UIImage(named: "cameraIconYellow")!,
        MainTheme.Pelican : UIImage(named: "cameraIconBlue")!,
    ]
    
    private let ageImages: [UIImage]  = [
        UIImage(named: "digit0")!, UIImage(named: "digit1")!, UIImage(named: "digit2")!, UIImage(named: "digit3")!, UIImage(named: "digit4")!, UIImage(named: "digit5")!, UIImage(named: "digit6")!, UIImage(named: "digit7")!, UIImage(named: "digit8")!, UIImage(named: "digit9")!, UIImage(named: "digit10")!, UIImage(named: "digit11")!, UIImage(named: "digit12")!
    ]
    
    // MARK: Layout Constants
    let backgroundImageTop: CGFloat = 56
    let backButtonTop: CGFloat = 29
    let backButtonLeading: CGFloat = 11
    let backButtonWidth: CGFloat = 26
    let backButtonHeight: CGFloat = 21
    
    let nameViewHeight: CGFloat = 190
    let nameViewWidth: CGFloat = 226
    let nameViewTop: CGFloat = 40
    let nameViewLeading: CGFloat = 75
    let nameViewTrailing: CGFloat = 74
    
    let nameLeading: CGFloat = 0
    let nameTrailing: CGFloat = 0
    let nameTop: CGFloat = 0
    let nameHeight: CGFloat = 100//50
    
    let ageImageTop: CGFloat = 13
    let ageImageHeight: CGFloat = 85
    let ageImageWidth: CGFloat = 96
    
    let swirlsTop: CGFloat = 38.2
    let swirlsOffset: CGFloat = 22
    let swrilsWidth: CGFloat = 50.2
    let swirlsHeight: CGFloat = 43.5
    
    let ageLabeltop: CGFloat = 14
    let ageLabelBottom: CGFloat = 0
    
    let babyViewTop: CGFloat = 20
    let babyViewHeight: CGFloat = 324
    let babyViewOffset: CGFloat = 50
    let babyViewBottom: CGFloat = 88
    
    let babyPlaceHolderImageViewOffset: CGFloat = 0
    let babyPlaceHolderHeight: CGFloat = 225
    
    let babyImageViewOffset: CGFloat = 6
    let babyImageViewHeight: CGFloat = 213 // 225 - babyImageViewOffset*2
    
    let shareButtonRadius: CGFloat = 12
    let shareButtonOffset: CGFloat = 17
    let shareButtonBottom: CGFloat = 0
    let shareButtonHeight: CGFloat = 42
    let shareButtonWidth: CGFloat = 179
    
    let nanitBottom: CGFloat = 20
    let nanitTop: CGFloat = 15
    
    let cameraButtonWidth: CGFloat = 36
    
    
    enum MainTheme: Int {
        case Fox, Elephant, Pelican
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !dataIsValid() {
            navigationController?.popViewController(animated: true)
        }
        
        imagePicker.delegate = self
        
        mainTheme = MainTheme(rawValue: Int.random(in: 0..<3)) ?? MainTheme.Elephant
        view.backgroundColor = backgroundColors[mainTheme]
        
        babyImageView.addSubview(cameraButton)
        
        view.sendSubviewToBack(backgroundImageView)
        nameView.bringSubviewToFront(nameLabel)
        nameView.bringSubviewToFront(ageImageView)
        babyView.sendSubviewToBack(babyPlaceHolderImageView)
        babyView.bringSubviewToFront(babyImageView)
        babyImageView.bringSubviewToFront(cameraButton)
        
        backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(self.pickAPicturePressed), for: .touchUpInside)
        
        nameLabel.text = "TODAY " + name! + " IS"
        nameLabel.textColor = .darkGreyBlue
        
        ageLabel.textColor = .darkGreyBlue
        
        shareButton.titleLabel?.minimumScaleFactor = 0.5
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shareButton.backgroundColor = .blush
        
        backgroundImageView.image = backgroundImages[mainTheme]
        babyImageView.contentMode = .scaleAspectFill
        babyImageView.image = picture
        babyPlaceHolderImageView.image = babyPlaceHolderImages[mainTheme]
        cameraButton.setImage(cameraImages[mainTheme], for: .normal)
        cameraButton.isUserInteractionEnabled = true
        view.clipsToBounds = true
        babyView.clipsToBounds = true
        babyImageView.clipsToBounds = true
        cameraButton.clipsToBounds = true
        babyPlaceHolderImageView.clipsToBounds = true
        
        if let date = birthDate,
           let (ageNumber, ageDescription) = calculateAge(for: date) {
            babyAgeNumber = ageNumber
            ageImageView.image = ageImages[ageNumber]
            ageLabel.text = ageDescription
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("calcSize(babyImageViewHeight, isWidth: true)=\(calcSize(babyImageViewHeight, isWidth: false))")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    //MARK: Layout
    private func calcSize(_ input: CGFloat, isWidth: Bool) -> CGFloat {
        let widthRatio = 375/611*view.frame.size.height/view.frame.size.width
        return isWidth ? input * widthRatio : input / widthRatio
    }

    private func setConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: calcSize(backButtonLeading, isWidth: true)).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: calcSize(backButtonTop, isWidth: false)).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: calcSize(backButtonWidth, isWidth: true)).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: calcSize(backButtonHeight, isWidth: false)).isActive = true
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: calcSize(backgroundImageTop, isWidth: false)).isActive = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: calcSize(nameViewLeading, isWidth: true)).isActive = true
        nameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: calcSize(-nameViewTrailing, isWidth: true)).isActive = true
        nameView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: calcSize(nameViewTop, isWidth: false)).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: calcSize(nameViewHeight, isWidth: false)).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: calcSize(nameLeading, isWidth: true)).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: calcSize(-nameTrailing, isWidth: true)).isActive = true
        nameLabel.topAnchor.constraint(equalTo: nameView.topAnchor, constant: calcSize(nameTop, isWidth: false)).isActive = true
        nameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: calcSize(nameHeight, isWidth: false)).isActive = true
        
        ageImageView.translatesAutoresizingMaskIntoConstraints = false
        ageImageView.centerXAnchor.constraint(equalTo: nameView.centerXAnchor).isActive = true
        ageImageView.topAnchor.constraint(greaterThanOrEqualTo: nameLabel.bottomAnchor, constant: ageImageTop).isActive = true
        ageImageView.heightAnchor.constraint(equalToConstant: calcSize(ageImageHeight, isWidth: false)).isActive = true
        ageImageView.widthAnchor.constraint(lessThanOrEqualToConstant: calcSize(ageImageWidth, isWidth: false)).isActive = true
        
        leftSwirls.translatesAutoresizingMaskIntoConstraints = false
        leftSwirls.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: calcSize(swirlsTop, isWidth: false)).isActive = true
        leftSwirls.leadingAnchor.constraint(greaterThanOrEqualTo: nameView.leadingAnchor).isActive = true
        leftSwirls.trailingAnchor.constraint(equalTo: ageImageView.leadingAnchor, constant: calcSize(-swirlsOffset, isWidth: true)).isActive = true
        leftSwirls.heightAnchor.constraint(equalToConstant: calcSize(swirlsHeight, isWidth: false)).isActive = true
        
        rightSwirls.translatesAutoresizingMaskIntoConstraints = false
        rightSwirls.topAnchor.constraint(equalTo: leftSwirls.topAnchor).isActive = true
        rightSwirls.trailingAnchor.constraint(greaterThanOrEqualTo: nameView.trailingAnchor).isActive = true
        rightSwirls.leadingAnchor.constraint(equalTo: ageImageView.trailingAnchor, constant: calcSize(swirlsOffset, isWidth: true)).isActive = true
        rightSwirls.heightAnchor.constraint(equalToConstant: calcSize(swirlsHeight, isWidth: false)).isActive = true
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.topAnchor.constraint(equalTo: ageImageView.bottomAnchor, constant: calcSize(ageLabeltop, isWidth: false)).isActive = true
        ageLabel.centerXAnchor.constraint(equalTo: nameView.centerXAnchor).isActive = true
        
        babyView.translatesAutoresizingMaskIntoConstraints = false
        babyView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: calcSize(babyViewOffset, isWidth: true)).isActive = true
        babyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: calcSize(-babyViewOffset, isWidth: true)).isActive = true
        babyView.topAnchor.constraint(greaterThanOrEqualTo: nameView.bottomAnchor, constant: calcSize(babyViewTop, isWidth: false)).isActive = true
        babyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: calcSize(-babyViewBottom, isWidth: false)).isActive = true
        
        babyPlaceHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        babyPlaceHolderImageView.centerXAnchor.constraint(equalTo: babyView.centerXAnchor).isActive = true
        babyPlaceHolderImageView.topAnchor.constraint(equalTo: babyView.topAnchor).isActive = true
        babyPlaceHolderImageView.heightAnchor.constraint(equalToConstant: calcSize(babyPlaceHolderHeight, isWidth: false)).isActive = true
        babyPlaceHolderImageView.widthAnchor.constraint(equalToConstant: calcSize(babyPlaceHolderHeight, isWidth: false)).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.centerXAnchor.constraint(equalTo: babyView.centerXAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: calcSize(shareButtonWidth, isWidth: true)).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: calcSize(shareButtonHeight, isWidth: false)).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: babyView.bottomAnchor).isActive = true
        
        nanitLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        nanitLogoImageView.centerXAnchor.constraint(equalTo: babyView.centerXAnchor).isActive = true
        nanitLogoImageView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: calcSize(-nanitBottom, isWidth: false)).isActive = true
        nanitLogoImageView.topAnchor.constraint(equalTo: babyPlaceHolderImageView.bottomAnchor, constant: calcSize(nanitTop, isWidth: false)).isActive = true
        
        babyImageView.translatesAutoresizingMaskIntoConstraints = false
        babyImageView.centerXAnchor.constraint(equalTo: babyPlaceHolderImageView.centerXAnchor).isActive = true
        babyImageView.topAnchor.constraint(equalTo: babyView.topAnchor, constant: calcSize(babyImageViewOffset, isWidth: true)).isActive = true
        babyImageView.widthAnchor.constraint(equalToConstant: calcSize(babyImageViewHeight, isWidth: false)).isActive = true
        babyImageView.heightAnchor.constraint(equalToConstant: calcSize(babyImageViewHeight, isWidth: false)).isActive = true
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.widthAnchor.constraint(equalToConstant: calcSize(cameraButtonWidth, isWidth: false)).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: calcSize(cameraButtonWidth, isWidth: false)).isActive = true
        let (hMult, vMult) = computeMultipliers(angle: 45)
        NSLayoutConstraint(item: cameraButton, attribute: .centerX, relatedBy: .equal, toItem: babyImageView!, attribute: .trailing, multiplier: hMult, constant: 0).isActive = true
        NSLayoutConstraint(item: cameraButton, attribute: .centerY, relatedBy: .equal, toItem: babyImageView!, attribute: .bottom, multiplier: vMult, constant: 0).isActive = true
        
        shareButton.layer.cornerRadius = calcSize(shareButtonRadius, isWidth: true)
        babyImageView.layer.cornerRadius = calcSize(babyImageViewHeight, isWidth: false)/2
        babyImageView.layoutIfNeeded()
        cameraButton.layoutIfNeeded()
    }
    
    private func computeMultipliers(angle: CGFloat) -> (CGFloat, CGFloat) {
        let radians = angle * .pi / 180
            
        let h = (1.0 + cos(radians)) / 2
        let v = (1.0 - sin(radians)) / 2
            
        return (h, v)
    }
    
    // MARK: Actions
    private func calculateAge(for date: Date)->(Int, String)? {
        //let years = Calendar.current.dateComponents([.year], from: date, to: Date()).year!
        if let months = Calendar.current.dateComponents([.month], from: date, to: Date()).month {
            let years = months / 12
            print("calculateAge: years=\(years), month=\(months)")
            if years > 0 {
                return (years, years == 1 ? "YEAR OLD!" : "YEARS OLD!")
            }
            else {
                return (months, months == 1 ? "MONTH OLD!" : "MONTHS OLD!")
            }
        }
        return nil
    }
    
    private func dataIsValid() -> Bool {
        if let _ = name,
           let _ = birthDate{
            return true
        }
        return false
    }
    
    @objc func cameraAction(_ sender: UIButton) {
        print("cameraAction")
    }
    
    
    // MARK: Navigation
    @objc func backAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UIImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            babyImageView.image = pickedImage
            UserDefaultsUtil().savePicture(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAPicturePressed(_ sender: UIButton) {
        print("pickAPicturePressed")
        
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
            alert.popoverPresentationController?.sourceView = babyImageView
            alert.popoverPresentationController?.sourceRect = babyImageView.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
       default:
            break
       }
        
       present(alert, animated: true, completion: nil)
    }
    
     func openCamera() {
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

    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
   }

}

