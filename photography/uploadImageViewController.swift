//
//  uploadImageViewController.swift
//  photography
//
//  Created by MAC on 01/12/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import ImagePicker

class uploadImageViewController: UIViewController,ImagePickerDelegate {

    @IBOutlet weak var openMyCamera: UIBarButtonItem!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    var selectImage: UIImage?
    var activityIndicatorView: UIActivityIndicatorView!
    
    @IBAction func cancelUploadImage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doUploadImage(_ sender: Any) {
        //present loading progress
        if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "progress") {
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            self.present(presentedViewController, animated: false, completion: nil)
        
            uploadButton.isEnabled = false
            
            //preparing selected image for upload
            if let imageData = UIImageJPEGRepresentation(selectedImage.image!, 0.5){
                
                let url = "http://batch57.com/application/api.php"
                let parameters = ["doUploadImage" : "do"]
                let name = "image"
                
                // use to upload image to server
                uploadFile(endUrl: url, fileData: imageData,withName: name, parameters: parameters, onCompletion: { (json) in
                    
                    ///////////////////////////////////////
                    // when upload is done check the return value and make disision
                    
                    let val = json! as! Int
                    if val == 1 {
                        //////////////
                    }
                    
                    ////////////////////////////////////////
                    
                    //dissmis loading progress view
                    presentedViewController.dismiss(animated: false, completion: nil)
                    self.dismiss(animated: false, completion: nil)
                }) { (error) in
                    print(error!)
                }
            }
        }
    }
    @IBAction func cameraButton(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
        present(imagePickerController, animated: true, completion: nil)
    }
    // ImagePickerController protocols
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        //
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        guard let image = images.first else {
            dismiss(animated: true, completion: nil)
            return
        }
        selectImage = image
        selectedImage.image = image
        dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController)
    {
        //
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(self.handelSelectImage))
        selectedImage.addGestureRecognizer(tapGestrue)
        selectedImage.isUserInteractionEnabled = true
    }
    
    // use to delegate imagepicker
    @objc func handelSelectImage() {
        let pickerContoroller = UIImagePickerController()
        pickerContoroller.delegate = self
        present(pickerContoroller, animated: true, completion: nil)
    }

}

// extend uiview to presented selected image  for user
extension uploadImageViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("\(info)")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectImage = image
            selectedImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
