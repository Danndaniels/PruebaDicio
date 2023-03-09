//
//  UpdateUserController.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 08/03/23.
//

import UIKit
class UpdateUserController: UIViewController {
    
    @IBOutlet weak var nameUserTxt: UITextField!
    @IBOutlet weak var firstNameUserTxt: UITextField!
    @IBOutlet weak var secondNameUserTxt: UITextField!
    @IBOutlet weak var emailUserTxt: UITextField!
    @IBOutlet weak var dateUserTxt: UITextField!
    @IBOutlet weak var streetUserTxt: UITextField!
    @IBOutlet weak var numberStreetUserTxt: UITextField!
    @IBOutlet weak var colonyUserTxt: UITextField!
    @IBOutlet weak var municipalityUserTxt: UITextField!
    @IBOutlet weak var stateUserTxt: UITextField!
    @IBOutlet weak var cpUserTxt: UITextField!
    @IBOutlet weak var photoUserImgView: UIImageView!
    
    var updateUserViewModel: UpdateUserViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConfig()
        self.initViewModel()
    }
    
    
    //MARK:- Inital SubViews
    func setupConfig(){
        self.nameUserTxt.text = updateUserViewModel.userItem?.userName
        self.firstNameUserTxt.text = updateUserViewModel.userItem?.userFirstName
        self.secondNameUserTxt.text = updateUserViewModel.userItem?.userSecondName
        self.emailUserTxt.text = updateUserViewModel.userItem?.userEmail
        self.dateUserTxt.text = updateUserViewModel.userItem?.userDate
        self.streetUserTxt.text = updateUserViewModel.userItem?.userStreet
        self.numberStreetUserTxt.text = updateUserViewModel.userItem?.userNumberStree
        self.colonyUserTxt.text = updateUserViewModel.userItem?.userColony
        self.municipalityUserTxt.text = updateUserViewModel.userItem?.userMunicipality
        self.stateUserTxt.text = updateUserViewModel.userItem?.userState
        self.cpUserTxt.text = updateUserViewModel.userItem?.userCP
        self.photoUserImgView.image = updateUserViewModel.userItem?.userImage.imageFromBase64()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:- Initalized ViewModel
    
    func initViewModel(){
        updateUserViewModel.didFetchResult = { [weak self]  in
            DispatchQueue.main.async {
                guard self != nil else {return}
                self?.dismiss(animated: true)
                
            }
        }
        
        updateUserViewModel.didStartFetch = { [weak self] in
            DispatchQueue.main.async {
                guard self != nil else {return}
                
            }
        }
        
        updateUserViewModel.searchFetchError = { [weak self] (error)in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                guard let error = error else {return}
                
            }
        }
    }
    
    @IBAction func selectedPhotoUser(){
        let imagePicker =  UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .camera
           present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func updateUser(){
        guard let name = self.nameUserTxt.text, !name.isEmpty, let firstName = self.firstNameUserTxt.text, !firstName.isEmpty, let secondName = self.secondNameUserTxt.text, !secondName.isEmpty, let email = self.emailUserTxt.text, !email.isEmpty, let dateUser = self.dateUserTxt.text, !dateUser.isEmpty else{
            self.alert(message: "Campos vacios", title: "ERROR")
            return
        }
        
        guard email.isValidEmail() else{
            self.alert(message: "Formato de correo incorrecto", title: "ERROR")
            return
        }
        
        guard dateUser.isValidDate() else{
            self.alert(message: "Formato de fecha incorrecto", title: "ERROR")
            return
        }
        
        
        guard let street = self.stateUserTxt.text, let colony = self.colonyUserTxt.text, let cp = self.cpUserTxt.text, let municipality = self.municipalityUserTxt.text, let state = self.stateUserTxt.text, let numberStreet = self.numberStreetUserTxt.text else{
            return
        }
        
        let dataUser = DataItem(calle: street, colonia: colony, cp: cp, delegacion: municipality, estado: state, imagen: self.photoUserImgView.image?.toBase64(addMimePrefix: true), numero: numberStreet)
        let user = UserItem(idUser: nil, nombre: name, apellidoPaterno: firstName, apellidoMaterno: secondName, email: email, fechaNac: dateUser, edad: 0, datos: dataUser)
        self.updateUserViewModel.performUpdate(user: user)
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate
extension UpdateUserController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    picker.dismiss(animated: true)

     if let image = info[.originalImage] as? UIImage {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        self.photoUserImgView.image = image.cropToBoundsCenter(width: 300, height: 300)
    }
  }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Imagen guardada", message: "La imagen se guardo correctamente", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}
