//
//  CustomImageView.swift
//  MandelbrotOSX4
//
//  Created by Michael O'Connell on 4/15/20.
//  Copyright © 2020 Michael O'Connell. All rights reserved.
//

import Cocoa

class CustomImageView: NSImageView {

    var xa: Double = startXA
    var xb: Double = startXB

    var ya: Double = startYA
    var yb: Double = startYB


    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }


    func createImage()
    {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue

        // var context: CGContext

        let context = CGContext(data: nil, width: WIDTH, height: HEIGHT, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo)

        // let context = getContext()

        for x in 0..<context!.width {
            for y in 0..<context!.height {
                let color = Mandelbrot(Px: x, Py: y)
                setPixel(context: context!, x: x, y: y, color: color)
            }
        }

        let xImage = context!.makeImage()
        self.image = NSImage(cgImage: xImage!, size: NSSize(width: xImage!.width, height: xImage!.height))
    }


    private func setPixel(context: CGContext, x: Int, y: Int, color: NSColor)
    {
        context.setLineWidth(1)
        context.setStrokeColor(color.cgColor)
        context.stroke(CGRect(x: CGFloat(x), y: CGFloat(y), width: 0.5, height: 0.5))
    }


    private func Mandelbrot(Px: Int, Py: Int) -> NSColor {

        let imgx = self.frame.width
        let imgy = self.frame.height

        let x0 = Double(Px) * (xb - xa) / Double(imgx) + xa
        let y0 = Double(Py) * (yb - ya) / Double(imgy) + ya

        var x: Double = 0.0
        var y: Double = 0.0

        var iteration: Int = 0
        // let max_iteration: Int = 1000
        let max_iteration: Int = 200


        while (((x * x) + (y * y) <= (2 * 2)) && (iteration < max_iteration)) {
            let xtemp = (x * x) - (y * y) + x0
            y = 2 * x * y + y0
            x = xtemp
            iteration += 1

            //        color := palette[iteration]
            //        plot(Px, Py, color)
        }

        let red = (iteration % 4) * 64
        let green = (iteration % 8) * 32
        let blue = (iteration % 16) * 16

        let retval: NSColor = NSColor(displayP3Red: CGFloat(red)/CGFloat(256), green: CGFloat(green)/CGFloat(256), blue: CGFloat(blue)/CGFloat(256), alpha: 1)

        // return UIColor.red
        return retval
    }

}


extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}

