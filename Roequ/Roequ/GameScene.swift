//
//  GameScene.swift
//  Roequ
//
//  Created by Devine Lu Linvega on 2015-04-27.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

import SpriteKit

enum tile:UInt32 {
	case outside = 1
	case floor = 2
	case section = 3
	case focus = 4
	case room = 5
	case roomCenter = 6
	case roomConnected = 7
	case spawn = 8
	case exit = 9
	case pickup = 10
	case limit = 99
}

let tileCountX:CGFloat = 39
let tileCountY:CGFloat = 39
var tileSize:CGFloat = 0
var currentStage:Stage = Stage()

class GameScene: SKScene {
	
    override func didMoveToView(view: SKView)
	{
		tileSize = self.frame.size.width/CGFloat(tileCountX)
		
		
		
//		drawView()
		
		drawStage()
    }
	
	func drawView()
	{
		let viewScale:CGFloat = 3
		let tileSize = self.frame.size.width/CGFloat(tileCountX/viewScale)
		let offset:CGFloat = (tileSize/2)
		let testArray: () = Stage().generate()
		
		let horizontalTiles = tileCountX/viewScale
		let verticalTiles = tileCountY/viewScale
		
		// Look at spawn
//		let spawnIndex = find(testArray, tile.spawn)
//		let spawnX:Int = Int(spawnIndex! % Int(tileCountX))
//		let spawnY:Int = Int(spawnIndex! / Int(tileCountY))
		
		
		var x = 0
		while x < Int(horizontalTiles) {
			
			var y = 0
			while y < Int(verticalTiles) {
				
				let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: tileSize, height: tileSize))
				sprite.position = CGPoint(x: CGFloat(x) * tileSize + offset, y: CGFloat(y) * tileSize + offset)
				
//				let tile = currentStage.tileAtLocation(x: x, y: y)
				
				
				if x % 2 == 0 {
					sprite.color = UIColor.whiteColor()
				}
				else{
					sprite.color = UIColor.redColor()
				}
	
				self.addChild(sprite)
				y += 1
			}
			x += 1
		}
		
	}
	
	func drawStage()
	{
		let testArray = Stage().activeStage
		
		let offset:CGFloat = (tileSize/2)
		
		var x:CGFloat = 0
		while(x < tileCountX){
			var y:CGFloat = 0
			while(y < tileCountX){
				let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: tileSize, height: tileSize))
				sprite.position = CGPoint(x: x * tileSize + offset, y: y * tileSize + offset)
				
				let lookup:Int = Int(tileCountX*y)+Int(x)
				if( testArray[lookup] == tile.outside ){
					sprite.color = UIColor.blackColor()
				}
				else if( testArray[lookup] == tile.section ){
					sprite.color = UIColor.redColor()
				}
				else if( testArray[lookup] == tile.focus ){
					sprite.color = UIColor.cyanColor()
				}
				else if( testArray[lookup] == tile.room ){
					sprite.color = UIColor.blueColor()
				}
				else if( testArray[lookup] == tile.roomCenter ){
					sprite.color = UIColor.yellowColor()
				}
				else if( testArray[lookup] == tile.spawn ){
					sprite.color = UIColor.yellowColor()
				}
				else if( testArray[lookup] == tile.exit ){
					sprite.color = UIColor.greenColor()
				}
				else if( testArray[lookup] == tile.pickup ){
					sprite.color = UIColor.blueColor()
				}
				else{
					sprite.color = UIColor.whiteColor()
				}
				
				self.addChild(sprite)
				y += 1
			}
			x += 1
		}
	}
	
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
	{
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
		
    }
}
