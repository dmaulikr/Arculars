//
//  GameScene.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
    }
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Setup background color
        let bgColor = SKColor(red: 247.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        self.backgroundColor = bgColor
        
        // Add GameLayer
        addChild(gameLayer)
        
        // Test: Create circles
        var circle1 = SKShapeNode(circleOfRadius: 100)
        circle1.antialiased = true
        circle1.position = CGPointMake(0, 0)
        circle1.strokeColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.2)
        circle1.lineWidth = 40
        circle1.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        circle1.physicsBody?.dynamic = false //set to false so it doesn't fall off scene.
        gameLayer.addChild(circle1)
        
        let arc1path = UIBezierPath(arcCenter: circle1.position, radius: 100, startAngle: 0.0, endAngle: CGFloat(M_PI / 2.0), clockwise: true)
        
        var arc1 = SKShapeNode(circleOfRadius: 100)
        arc1.lineCap = kCGLineCapRound
        arc1.path = arc1path.CGPath
        arc1.antialiased = true
        arc1.position = CGPointMake(0, 0)
        arc1.strokeColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        arc1.lineWidth = 40
        arc1.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        arc1.physicsBody?.dynamic = false //set to false so it doesn't fall off scene.
        gameLayer.addChild(arc1)
    }

}
