//
//  CreateEventVC.swift
//  MDB Social
//
//  Created by Rikio Dahlgren on 11/7/21.
//

import UIKit
import SwiftUI
import Foundation
import NotificationBannerSwift
import FirebaseFirestore

class CreateEventVC: UIViewController, UINavigationControllerDelegate {
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create Event"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 15

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let eventNameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Event Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let eventDescriptionTextField: AuthTextField = {
        let tf = AuthTextField(title: "Description:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let datePicker: UIDatePicker =  {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    private let imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        return ip
    }()
    
    private let imagePickerButton: UIButton = {
        let btn = UIButton()
        btn.layer.backgroundColor = UIColor.systemGray.cgColor
        btn.setTitle("Pick an image", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 15
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let submitButton: UIButton = {
            let btn = UIButton()
            btn.backgroundColor = .primary
            btn.setImage(UIImage(systemName: "plus"), for: .normal)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
            btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
            btn.tintColor = .white
            btn.layer.cornerRadius = 25
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
    
    private let cancelButton: UIButton = {
            let btn = UIButton()
            btn.backgroundColor = .primary
            btn.setImage(UIImage(systemName: "xmark"), for: .normal)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
            btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
            btn.tintColor = .white
            btn.layer.cornerRadius = 25
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
    
    private var selectedDate: Date?
    private var selectedImage: UIImage?
    private var selectedImageData: Data?
    private var imageMeta: Any?
    private var selectedImageURL: URL?
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    private let contentEdgeInset = UIEdgeInsets(top: 120, left: 20, bottom: 30, right: 20)
    private let buttonHeight: CGFloat = 44.0
    
    override func viewDidLoad() {
        view.backgroundColor = .background
    
        view.addSubview(stack)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
        ])
        
        view.addSubview(cancelButton)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 10),
            submitButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            submitButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
        
        stack.addArrangedSubview(eventNameTextField)
        stack.addArrangedSubview(eventDescriptionTextField)
        stack.addArrangedSubview(datePicker)
        stack.addArrangedSubview(imagePickerButton)
        
        cancelButton.layer.cornerRadius = buttonHeight / 2
        submitButton.layer.cornerRadius = buttonHeight / 2
        
        imagePicker.delegate = self
 
        datePicker.addTarget(self, action: #selector(didCreateDate(_:)), for: .valueChanged)
        cancelButton.addTarget(self, action: #selector(didTapCancel(_:)), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(didTapCreateEvent(_:)), for: .touchUpInside)
        imagePickerButton.addTarget(self, action: #selector(didTapPickImage(_:)), for: .touchUpInside)
    }
    
    @objc func didCreateDate(_ datePicker: UIDatePicker) {
        let d: Date = datePicker.date
        selectedDate = d
    }
    
    @objc func didTapCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        }
    
    @objc func didTapCreateEvent(_ sender: UIButton) {
        guard let eventName = eventNameTextField.text, eventName != "" else {
            showErrorBanner(withTitle: "Event name missing",
                            subtitle: "Please provide name")
            return
        }
        
        guard let eventDescription = eventDescriptionTextField.text, eventDescription != "" else {
            showErrorBanner(withTitle: "Event description missing",
                            subtitle: "Please provide a description")
            return
        }
        
        if (eventDescription.count > 140) {
            let over = 140 - eventDescription.count
            showErrorBanner(withTitle: "Event description too long",
                            subtitle: "Please reduce by \(over) characters")
            return
        }
        
        if (selectedDate == nil) {
            showErrorBanner(withTitle: "Missing event date",
                            subtitle: "Please select a date")
            return
        }
        
        if (selectedImageData == nil) {
            showErrorBanner(withTitle: "Missing event image",
                            subtitle: "Please select an image")
            return
        }
        
        if (selectedImage == nil) {
            showErrorBanner(withTitle: "Missing event image",
                            subtitle: "Please select an image")
            return
        }
        let currID: SOCUserID = SOCAuthManager.shared.currentUser!.uid ?? ""
        
        let storageRef = SOCStorage.shared.storage.reference().child(UUID().uuidString + ".jpeg")
        _ = storageRef.putData(selectedImageData!, metadata: SOCStorage.shared.metadata) { (metadata, error) in
            storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else { return }

            let event: SOCEvent = SOCEvent(name: eventName, description: eventDescription, photoURL: downloadURL.relativeString, startTimeStamp: Timestamp(date: self.selectedDate!), creator: currID, rsvpUsers: [])
              
            SOCDatabaseRequest.shared.db.collection("events").document(event.id!)
            SOCDatabaseRequest.shared.setEvent(event, completion: {})
          }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapPickImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        alert.view.addSubview(UIView())
        present(alert, animated: false, completion: nil)
    }
    
    private func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Error", message: "Camera unavailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.view.addSubview(UIView())
            present(alert, animated: false, completion: nil)
        }
    }
    
    private func openGallery() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            imagePicker.mediaTypes = ["public.image"]
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Error", message: "Gallery unavailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: false, completion: nil)
        }
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}


extension CreateEventVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
           //  selectedImage = image.resized(withPercentage: 0.1)
            selectedImageData = selectedImage?.jpegData(compressionQuality: 0.1)
        }
        if let url = info[.imageURL] as? URL {
            selectedImageURL = url
        }
        imageMeta = info[.mediaMetadata]
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//extension UIImage {
//    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
//            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
//            let format = imageRendererFormat
//            format.opaque = isOpaque
//            return UIGraphicsImageRenderer(size: canvas, format: format).image {
//                _ in draw(in: CGRect(origin: .zero, size: canvas))
//            }
//    }
//}
