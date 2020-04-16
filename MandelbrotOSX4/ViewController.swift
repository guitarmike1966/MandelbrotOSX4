//
//  ViewController.swift
//  MandelbrotOSX4
//
//  Created by Michael O'Connell on 4/15/20.
//  Copyright © 2020 Michael O'Connell. All rights reserved.
//

import Cocoa

let WIDTH = 1024
let HEIGHT = 768

let Rate = 0.0033

let startXA = -2.5
let startXB = 1.5
let startYA = -1.5
let startYB = 1.5


class ViewController: NSViewController {

    @IBOutlet weak var MandelbrotImageView: NSImageView!
    @IBOutlet weak var StartButton: NSButton!
    @IBOutlet weak var StartFrameText: NSTextField!
    @IBOutlet weak var EndFrameText: NSTextField!
    @IBOutlet weak var ImageCountLabel: NSTextField!

    var xxa: Double = startXA
    var xxb: Double = startXB

    var xya: Double = startYA
    var xyb: Double = startYB

    var imageCounter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func StartButtonClick(_ sender: Any) {

        let startNumber: Int = Int(StartFrameText.stringValue)!
        let endNumber: Int = Int(EndFrameText.stringValue)!

        for x in startNumber..<endNumber {

            // let newImage = CustomImageView(frame: NSRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
            let newImage = CustomImage(XA: xxa, XB: xxb, YA: xya, YB: xyb)

            (xxa,xxb) = calc(a: startXA, b: startXB, iter: x, rate: Rate, portionA: 0.3118, portionB: 0.6882)
            (xya,xyb) = calc(a: startYA, b: startYB, iter: x, rate: Rate, portionA: 0.609, portionB: 0.391)

            newImage.xa = xxa
            newImage.xb = xxb
            newImage.ya = xya
            newImage.yb = xyb

            MandelbrotImageView.image = newImage.createImage()

            let downloadURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

            self.imageCounter = x
            let fileName = String(format: "new-mandelbrot-%04d.png", self.imageCounter)
            let destinationURL = downloadURL.appendingPathComponent(fileName)
            let saveResult = self.MandelbrotImageView.image!.pngWrite(to: destinationURL)

            DispatchQueue.main.async {
                self.ImageCountLabel.stringValue = String(format: "%05d", self.imageCounter)
            }

            // newImage.removeFromSuperview()
            // newImage = nil
        }

    }


    private func calc(a: Double, b: Double, iter: Int, rate: Double, portionA: Double, portionB: Double) -> (Double,Double) {
        var aReturn: Double
        var bReturn: Double

        let Width = b - a
        let newWidth = Width * pow((1 - (rate)),Double(iter))

        let aChange = (Width - newWidth) * portionA
        let bChange = (Width - newWidth) * portionB
        aReturn = a + aChange
        bReturn = b - bChange

        return (aReturn,bReturn)
    }
    
    
    private func drawImage() {
        
    }


}

