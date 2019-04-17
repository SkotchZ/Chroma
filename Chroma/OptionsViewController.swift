//
//  OptionsViewController.swift
//  Chroma
//
//  Created by Игорь Скачков on 4/12/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var commonData: Model! = Model()
    
    @IBOutlet weak var RedValueLabel: UILabel!
    @IBOutlet weak var GreenValueLabel: UILabel!
    @IBOutlet weak var BlueValueLable: UILabel!
    @IBOutlet weak var ColorSquare: UILabel!
    @IBOutlet weak var DrawingMode: UISegmentedControl!
    
    var imagePicker = UIImagePickerController()
    var red: Float = 0
    var green: Float = 0
    var blue: Float = 0
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if DrawingMode.selectedSegmentIndex == 0{
            commonData.drawingColor = ColorSquare.backgroundColor
        }
        else{
            commonData.drawingColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0)
        }
        commonData.isEraseMode = DrawingMode.selectedSegmentIndex == 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commonData = (self.tabBarController as! CustomTabBarController).model
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BlueValueChanged(_ sender: UISlider) {
        BlueValueLable.text = String(Int(255 * sender.value))
        blue = sender.value
        ColorSquare.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
    
    @IBAction func GreenValueChanged(_ sender: UISlider) {
        GreenValueLabel.text = String(Int(255 * sender.value))
        green = sender.value
        ColorSquare.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
    
    @IBAction func RedValueChaned(_ sender: UISlider) {
        RedValueLabel.text = String(Int(255 * sender.value))
        red = sender.value
        ColorSquare.backgroundColor = UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
    
    @IBAction func DrawChanged(_ sender: UISegmentedControl) {
        
    }
    
    
    
    @IBAction func saveImage2(_ sender: Any) {
        var foregraund = commonData.foregraund
        var background = commonData.background
        if foregraund==nil
        {
            foregraund = UIImage(color: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1), size: commonData.size!)
        }
        if background==nil
        {
            background = UIImage(color: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1), size: commonData.size!)
        }
       
        let size = commonData.size
        UIGraphicsBeginImageContext(size!)
        
        let areaSize = CGRect(x: 0, y: 0, width: size!.width, height: size!.height)
        background!.draw(in: areaSize)
        foregraund!.draw(in: areaSize, blendMode: CGBlendMode.normal, alpha: 1)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
//        let compressedImage = UIImage(data: newImage!)
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved" , message: "your image was saved", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func loadImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            commonData.background = image
        }
        else{
            // TODO
        }
        self.dismiss(animated: true, completion: nil)
    }

}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
