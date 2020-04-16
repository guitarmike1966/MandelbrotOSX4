//
//  CustomImage.swift
//  MandelbrotOSX4
//
//  Created by Michael O'Connell on 4/15/20.
//  Copyright © 2020 Michael O'Connell. All rights reserved.
//

import Foundation
import Cocoa

class CustomImage {

    var xa: Double = startXA
    var xb: Double = startXB

    var ya: Double = startYA
    var yb: Double = startYB

    init(XA: Int, XB: Int, YA: Int, YB: Int) {
        self.xa = Double(XA)
        self.xb = Double(XB)
        self.ya = Double(YA)
        self.yb = Double(YB)
    }

    
    init(XA: Double, XB: Double, YA: Double, YB: Double) {
        self.xa = XA
        self.xb = XB
        self.ya = YA
        self.yb = YB
    }


    func createImage() -> NSImage {

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

        let xImage = context!.makeImage()!
        
        return NSImage(cgImage: xImage, size: NSSize(width: WIDTH, height: HEIGHT))
    }


    private func setPixel(context: CGContext, x: Int, y: Int, color: NSColor)
    {
        context.setLineWidth(1)
        context.setStrokeColor(color.cgColor)
        context.stroke(CGRect(x: CGFloat(x), y: CGFloat(y), width: 0.5, height: 0.5))
    }


    private func Mandelbrot(Px: Int, Py: Int) -> NSColor {

        let imgx = WIDTH
        let imgy = HEIGHT

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
