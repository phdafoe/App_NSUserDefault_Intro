//
//  ViewController.swift
//  App_NSUserDefault_Intro
//
//  Created by formador on 22/6/16.
//  Copyright © 2016 Cice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - CONSTANTES
    static let nombre = "NOMBRE"
    static let apellido = "APELLIDO"
    static let direccion = "DIRECCION"
    static let telefono = "TELEFONO"
    static let ultimaActualizacion = "ULTIMA_ACTUALIZACION"
    static let imagenPerfil = "IMAGEN_PERFIL"
    
    let prefs = UserDefaults.standard
    let dateFormatter = DateFormatter()
    

    //MARK: - IBOUTLET
    @IBOutlet weak var myImagenPerfil: UIImageView!
    @IBOutlet weak var myLabelActualizadatos: UILabel!
    @IBOutlet weak var myNombreTF: UITextField!
    @IBOutlet weak var myApellidoTF: UITextField!
    @IBOutlet weak var myDireccionTF: UITextField!
    @IBOutlet weak var myTelefonoTF: UITextField!
    

    //MARK: - IBACTION
    
    @IBAction func salvarDatosNSUserdefault(_ sender: AnyObject) {
        
        if (myNombreTF.text!.characters.count > 0) && (myApellidoTF.text!.characters.count > 0) && (myDireccionTF.text!.characters.count > 0) && (myTelefonoTF.text!.characters.count > 0){
            
            prefs.set(myNombreTF.text, forKey: ViewController.nombre)
            prefs.set(myApellidoTF.text, forKey: ViewController.apellido)
            prefs.set(myDireccionTF.text, forKey: ViewController.direccion)
            prefs.set(myTelefonoTF.text, forKey: ViewController.telefono)
            
            let imageData = UIImageJPEGRepresentation(myImagenPerfil.image!, 0.5)
            prefs.set(imageData, forKey: ViewController.imagenPerfil)
            
            let actualizacion = Date()
            prefs.set(actualizacion, forKey: ViewController.ultimaActualizacion)
            
            showAlertVC("Hola", messageData: "Estimado usuario se ha salvado correctamente")
            
        }else{
            showAlertVC("Hola", messageData: "Estimado usuario no se ha logrado salvar la informacion")
        }
        
        
    }
    
    @IBAction func actualizarInformacionNSUserdefault(_ sender: AnyObject) {

        if let imageData = prefs.object(forKey: ViewController.imagenPerfil) as? Data{
            let storageImage = UIImage(data: imageData)
            myImagenPerfil.image = storageImage
        }
        
        dateFormatter.dateStyle = .medium
        
        if let lastUpdateStore = prefs.object(forKey: ViewController.ultimaActualizacion) as? Date{
            myLabelActualizadatos.text = "Ultima actualizacion" + " " + dateFormatter.string(from: lastUpdateStore)
        }else{
            myLabelActualizadatos.text = "Ultima Actualización NO REALIZADA"
        }
        
        if let nombreData = prefs.string(forKey: ViewController.nombre){
            myNombreTF.text = nombreData
        }
         
        if let apellidoData = prefs.string(forKey: ViewController.apellido){
            myApellidoTF.text = apellidoData
        }
        
        if let direccionData = prefs.string(forKey: ViewController.direccion){
            myDireccionTF.text = direccionData
        }
        
        if let telefonoData = prefs.string(forKey: ViewController.telefono){
            myTelefonoTF.text = telefonoData
        }
        
        
    }
    
    
    //MARK: - LIFE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Habilitamos la Imagen para que me ejecute el patron de diseño TARGET / ACTION
        myImagenPerfil.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.actionGesture(_:)))
        myImagenPerfil.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - UTILS
    func actionGesture(_ gestureRecognizer : UITapGestureRecognizer){
        pickerPhoto()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlertVC(_ titleData : String, messageData : String){
        let alertVC = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { Void in
            self.myTelefonoTF.text = ""
            self.myNombreTF.text = ""
            self.myApellidoTF.text = ""
            self.myDireccionTF.text = ""
            self.myImagenPerfil.image = UIImage(named: "placeholder.jpg")
            
        }))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

//MARK: - DELEGATE UIIMAGEPICKER / PHOTO
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func pickerPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoMenu()
        }else{
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu(){
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Tomar Foto", style: .default) { Void  in
            self.takePhotowithCamera()
        }
        let chooseFromLibraryAction = UIAlertAction(title: "Escoge de la Librería", style: .default) { Void  in
            self.choosePhotoFromLibrary()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(takePhotoAction)
        alertVC.addAction(chooseFromLibraryAction)
        
        present(alertVC, animated: true, completion: nil)
   
    }
    
    func takePhotowithCamera(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func choosePhotoFromLibrary(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        myImagenPerfil.image = image
        self.dismiss(animated: true, completion: nil)
    }
 
    
    
}


































