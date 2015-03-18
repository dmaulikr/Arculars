// Playground - noun: a place where people can play

import UIKit
import SpriteKit

var radius : CGFloat = 100.0
var sizeOfArc = CGFloat(M_PI / 2)
var thickness = 40.0


let arcpath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: 0.0, endAngle: sizeOfArc, clockwise: true)


var arc = UIBezierPath()
arc.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 100, startAngle: 0, endAngle: CGFloat(M_PI / 2), clockwise: true)

arc.addArcWithCenter(CGPoint(x: 0, y: 90), radius: 10.0, startAngle: CGFloat(M_PI / 2), endAngle: CGFloat(3 * M_PI / 2), clockwise: true)
arc.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 80, startAngle: 0, endAngle: CGFloat(M_PI / 2), clockwise: true)
arc.addArcWithCenter(CGPoint(x: 90, y: 0), radius: 10.0, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)

var arc2 = UIBezierPath()

var currentpoint = CGPointMake(radius, 0)
var physicsparts = 10;
var offsetangle = CGFloat(sizeOfArc / CGFloat(physicsparts))

for var index = 0; index < physicsparts + 1; index++ {
    arc2.addArcWithCenter(currentpoint, radius: 10, startAngle: CGFloat(2 * M_PI), endAngle: 0, clockwise: true)
    currentpoint = CGPointApplyAffineTransform(currentpoint, CGAffineTransformMakeRotation(offsetangle));
}