//
//  ModelController.swift
//  Chroma
//
//  Created by Игорь Скачков on 4/14/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import UIKit

class Model {
    public var background: UIImage!
    public var foregraund: UIImage!
    public var size: CGSize!
    public var drawingColor: UIColor!
    public var isEraseMode: Bool
    init() {
        self.background = nil
        self.foregraund = nil
        self.drawingColor = nil
        self.size = nil
        isEraseMode = false
    }
    init(background: UIImage, foregraund: UIImage, isDrawing: Bool, drawingColor: UIColor, isEraseMode: Bool, size: CGSize) {
        self.background = background
        self.foregraund = foregraund
        self.drawingColor = drawingColor
        self.isEraseMode = isEraseMode
        self.size = size
    }
}
