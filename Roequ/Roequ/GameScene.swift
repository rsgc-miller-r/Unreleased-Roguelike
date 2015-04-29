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
var currentStage:Stage!
var player:Player!

class GameScene: SKScene {
	
    override func didMoveToView(view: SKView)
	{
		tileSize = self.frame.size.width/CGFloat(tileCountX)
		
		currentStage = Stage()
		player = Player(spawn: currentStage.spawn)
		
		gameView()
//		mapView()
    }
	
	func gameView()
	{
		let viewScale:CGFloat = 2
		let tileSize = self.frame.size.width/CGFloat(tileCountX/viewScale)
		let offset:CGFloat = (tileSize/2)
		let stage = currentStage.activeStage
		
		let horizontalTiles = tileCountX/viewScale
		let verticalTiles = tileCountY/viewScale
		
		var x = 0
		while x < Int(horizontalTiles) {
			
			var y = 0
			while y < Int(verticalTiles) {
				
				let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: tileSize, height: tileSize))
				sprite.position = CGPoint(x: CGFloat(x) * tileSize + offset, y: CGFloat(y) * tileSize + offset)
				
				let horizontalOffset = player.x - Int(horizontalTiles/2)
				let verticalOffset = player.y - Int(verticalTiles/2) - 1
				
				let targetTile = currentStage.tileAtLocation(x + horizontalOffset, y: y + verticalOffset )
				
				if( targetTile == tile.outside ){ sprite.color = UIColor.blackColor() }
				else if( targetTile == tile.section ){ sprite.color = UIColor.redColor() }
				else if( targetTile == tile.focus ){ sprite.color = UIColor.cyanColor() }
				else if( targetTile == tile.floor ){ sprite.color = UIColor.whiteColor() }
				else if( targetTile == tile.roomCenter ){ sprite.color = UIColor.yellowColor() }
				else if( targetTile == tile.spawn ){ sprite.color = UIColor.yellowColor() }
				else if( targetTile == tile.exit ){ sprite.color = UIColor.greenColor()	}
				else if( targetTile == tile.pickup ){ sprite.color = UIColor.blueColor() }
				else{ sprite.color = UIColor.cyanColor() }
	
				self.addChild(sprite)
				y += 1
			}
			x += 1
		}
		
	}
	
	func mapView()
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
			println("touched:\(location.x) \(location.y)")
			
			if location.y > 300 { player.move(0, yUpdate: 1) }
			else if location.y < 0   { player.move(0, yUpdate: -1) }
			else if location.x < 160   { player.move(-1, yUpdate: 0) }
			else { player.move(1, yUpdate: 0) }
			
			turn()
        }
    }
	
	func turn()
	{
		self.removeAllChildren()
		gameView()
	}
   
    override func update(currentTime: CFTimeInterval) {
		
    }
}
