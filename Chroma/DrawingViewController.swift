//
//  DrawingViewController.swift
//  Chroma
//
//  Created by Игорь Скачков on 4/12/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {

    var commonData: Model! = Model()
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var canvasView: UIImageView!
    
    var taped = false
    var lastPoint = CGPoint.zero
    var strokeWidth: CGFloat = 12.0
    var strokeColor = UIColor.blue
    var linePath: UIBezierPath?
    

    override func viewWillDisappear(_ animated: Bool) {
        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        let image = renderer.image { (ctx) in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        commonData.background = img.image
        commonData.foregraund = canvasView.image
        commonData.size = canvasView.frame.size
    }
    override func viewDidAppear(_ animated: Bool) {
        commonData = (self.tabBarController as! CustomTabBarController).model
        img.image = commonData.background
        if commonData.drawingColor != nil{
            strokeColor = commonData.drawingColor
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearCanvas(_ sender: Any) {
        
    }
    
   
    var imageView: UIImageView {
        return canvasView as! UIImageView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = UIImage()
        canvasView.isUserInteractionEnabled = true
        let press = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        canvasView.addGestureRecognizer(press)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taped = true
        if let touch = touches.first {
            lastPoint = touch.location(in: canvasView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        taped = false
        if let touch = touches.first {
            let currentPoint = touch.location(in: canvasView)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if taped {
            drawLine(from: lastPoint, to: lastPoint)
        }
    }
    
    @objc func longPress() {
        let activity = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
        present(activity, animated:true, completion:nil)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint:CGPoint) {
        
        UIGraphicsBeginImageContext(canvasView.frame.size)
        imageView.image?.draw(in: CGRect(origin: CGPoint.zero, size: canvasView.frame.size))
//        if commonData.isEraseMode
//        {
//            imageView.image?.draw(in: CGRect(origin: CGPoint.zero, size: canvasView.frame.size), blendMode: CGBlendMode.clear, alpha: 1)
//        }else{
//            imageView.image?.draw(in: CGRect(origin: CGPoint.zero, size: canvasView.frame.size), blendMode: CGBlendMode.copy, alpha: 1)
//        }
        let linePath = UIBezierPath()
        
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        
        strokeColor.setStroke()
        linePath.lineWidth = strokeWidth
        linePath.lineCapStyle = .round
        linePath.lineJoinStyle = .round
        if commonData.isEraseMode{
            linePath.stroke(with: CGBlendMode.copy, alpha: 1)
        }
        else
        {
            linePath.stroke(with: CGBlendMode.normal, alpha: 1)
        }
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
