//
//  ViewController.swift
//  Macro-Image
//
//  Created by Veeresh Kumbar on 12/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var macroView: MacroView!
    @IBOutlet weak var changeBGColorButton: UIButton!
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var didApplyFilter: Bool = false
    
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupUI()
    }
    
    
    func setupUI() {
        macroView.layer.borderColor = UIColor.black.cgColor
        macroView.layer.borderWidth = 2
    }
    
    @IBAction func addTextAction(_ sender: Any) {
        guard let text = textField.text, !text.isEmpty else {
            let alertController = UIAlertController(title: "Please add text", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alertController, animated: true)
            return
        }
        macroView.addText(text)
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    
    /// Apply or remove the applied filter
    @IBAction func applyFilterAction(_ sender: Any) {
        if didApplyFilter {
            macroView.removeFilter()
            didApplyFilter = false
            applyFilterButton.setTitle("Apply Filter", for: .normal)
            changeBGColorButton.isEnabled = true
            addImageButton.isEnabled = true
            addTextButton.isEnabled = true
        } else {
            macroView.applyBlackAndWhiteFilter()
            didApplyFilter = true
            applyFilterButton.setTitle("Remove Filter", for: .normal)
            changeBGColorButton.isEnabled = false
            addImageButton.isEnabled = false
            addTextButton.isEnabled = false
        }
        
    }
    
    /// Adds the image to BG Layer of macro view
    /// it shows the image picker from which users can select the image to add
    @IBAction func addImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePickerController.delegate = self
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    /// Changes the color of BG layer.
    /// It will show a action sheet where user can select color from 3 options, 3 options are for demo we can include color templates in future
    @IBAction func changeBGColorAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Please choose color", message: nil, preferredStyle: .actionSheet)
        
        let redAction = UIAlertAction(title: "Red", style: .default) { [weak self] action in
            self?.macroView.bgColor = .red
        }
        
        let grayAction = UIAlertAction(title: "Gray", style: .default) { [weak self] action in
            self?.macroView.bgColor = .gray
        }
        
        let yellowAction = UIAlertAction(title: "Yellow", style: .default) { [weak self] action in
            self?.macroView.bgColor = .yellow
        }
        
        let whiteAction = UIAlertAction(title: "White", style: .default) { [weak self] action in
            self?.macroView.bgColor = .white
        }
        
        alertController.addAction(redAction)
        alertController.addAction(grayAction)
        alertController.addAction(yellowAction)
        alertController.addAction(whiteAction)
        
        self.present(alertController, animated: true)
        
    }
    
    
    @IBAction func shareImageAction(_ sender: Any) {
        shareImage()
    }
    
    private func shareImage() {
        guard let image = macroView.createImage() else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[.originalImage] as? UIImage {
                self.macroView.addImage(image)
            }
        })
    }
    
}

