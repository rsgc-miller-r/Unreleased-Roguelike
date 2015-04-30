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
	case wall = 5
	case spawn = 8
	case exit = 9
	case pickup = 10
	case limit = 99
}

let tileCountX:CGFloat = 39
let tileCountY:CGFloat = 39
var tileSizeX:CGFloat = 0
var tileSizeY:CGFloat = 0
var currentStage:Stage!
var player:Player!


var screenSize:CGRect = CGRectMake(0, 0, 0, 0)

var renderCanvas = SKSpriteNode()
let renderScale:CGFloat = 2
let renderSize = CGSizeMake(screenSize.width/renderScale, screenSize.height/renderScale)

class GameScene: SKScene {
	
    override func didMoveToView(view: SKView)
	{
		tileSizeX = self.frame.size.width/CGFloat(tileCountX)
		tileSizeY = tileSizeX * 1
		
		currentStage = Stage()
		player = Player(spawn: currentStage.spawn)
		
//		gameView()
//		mapView()
		
		scene?.addChild(renderCanvas)
		renderCanvas.size = view.frame.size
		renderCanvas.position = CGPoint(x: 0, y: 0 )
		
		newDraw()
		
    }
	
	func newDraw()
	{
		let viewScale:CGFloat = 2
		
		UIGraphicsBeginImageContextWithOptions( renderSize, false, 0)
		var context = UIGraphicsGetCurrentContext()
		CGContextSetShouldAntialias(context, false)
		
		let horizontalTiles = tileCountX/viewScale
		let verticalTiles = tileCountY/viewScale
		
		var x = 0
		while x < Int(horizontalTiles) {
			
			var y = 0
			while y < Int(verticalTiles) {
				
				let horizontalOffset = player.x - Int(horizontalTiles/2)
				let verticalOffset = player.y - Int(verticalTiles/2) - 1
				
				let targetTile = currentStage.tileAtLocation(x + horizontalOffset, y: y + verticalOffset )
				
				if( targetTile == tile.floor ){
					
					CGContextAddRect(context, CGRectMake(tileSizeX * CGFloat(x),tileSizeY * CGFloat(y),4,4))
					CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
					CGContextFillPath(context)
					
				}
				else if( targetTile == tile.section ){
						
						CGContextAddRect(context, CGRectMake(tileSizeX * CGFloat(x),tileSizeY * CGFloat(y),4,4))
						CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
						CGContextFillPath(context)
						
					}
				else if( targetTile == tile.limit ){
					
					CGContextAddRect(context, CGRectMake(tileSizeX * CGFloat(x),tileSizeY * CGFloat(y),2,2))
					CGContextSetFillColorWithColor(context, UIColor.cyanColor().CGColor)
					CGContextFillPath(context)
					
				}
				
				// Add Player
				if x == Int(horizontalTiles/2) && y == Int(verticalTiles/2) {
					
					CGContextAddRect(context, CGRectMake(tileSizeX * CGFloat(x),tileSizeY * CGFloat(y),2,2))
					CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
					CGContextFillPath(context)
				}
				
				y += 1
			}
			
			x += 1
		}
		
		
		let screenSave = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		let texture = SKTexture(image: screenSave)
		texture.filteringMode = SKTextureFilteringMode.Nearest
		renderCanvas.texture = texture
	}
	
	func gameView()
	{

		let viewScale:CGFloat = 2
		let tileSizeX = self.frame.size.width/CGFloat(tileCountX/viewScale)
		let tileSizeY = tileSizeX * 1.5
		let offsetX:CGFloat = (tileSizeX/2)
		let offsetY:CGFloat = (tileSizeY/2)
		let stage = currentStage.activeStage
		
		let horizontalTiles = tileCountX/viewScale
		let verticalTiles = tileCountY/viewScale
		
		println("\(tileSizeX) x \(tileSizeY)")
		
		var x = 0
		while x < Int(horizontalTiles) {
			
			var y = 0
			while y < Int(verticalTiles) {
				
				let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: tileSizeX, height: tileSizeY))
				sprite.position = CGPoint(x: CGFloat(x) * tileSizeX + offsetX - screenSize.size.width/2, y: CGFloat(y) * tileSizeY + offsetY)
				
				let horizontalOffset = player.x - Int(horizontalTiles/2)
				let verticalOffset = player.y - Int(verticalTiles/2) - 1
				
				let targetTile = currentStage.tileAtLocation(x + horizontalOffset, y: y + verticalOffset )
				
				if( targetTile == tile.outside ){ sprite.color = UIColor.blackColor() }
				else if( targetTile == tile.section ){ sprite.color = UIColor.redColor() }
				else if( targetTile == tile.focus ){ sprite.color = UIColor.cyanColor() }
				else if( targetTile == tile.floor ){ sprite.color = UIColor.whiteColor() }
				else if( targetTile == tile.wall ){ sprite.color = UIColor.brownColor() }
				else if( targetTile == tile.spawn ){ sprite.color = UIColor.yellowColor() }
				else if( targetTile == tile.exit ){ sprite.color = UIColor.greenColor()	}
				else if( targetTile == tile.pickup ){ sprite.color = UIColor.blueColor() }
				else{ sprite.color = UIColor.cyanColor() }
				
				// Add Player
				if x == Int(horizontalTiles/2) && y == Int(verticalTiles/2) {
					sprite.color = UIColor.purpleColor()
				}
				
				if( targetTile != tile.outside && targetTile != tile.limit ){
					self.addChild(sprite)
				}
				
				
				y += 1
			}
			x += 1
		}
	
	}
	
	func mapView()
	{
		let testArray = Stage().activeStage
		
		let offset:CGFloat = (tileSizeX/2)
		
		var x:CGFloat = 0
		while(x < tileCountX){
			var y:CGFloat = 0
			while(y < tileCountX){
				let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: tileSizeX, height: tileSizeX))
				sprite.position = CGPoint(x: x * tileSizeX + offset, y: y * tileSizeX + offset)
				
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
				else if( testArray[lookup] == tile.spawn ){
					sprite.color = UIColor.yellowColor()
				}
				else if( testArray[lookup] == tile.wall ){
					sprite.color = UIColor.brownColor()
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
			
			println("!  TOUCH | x: \(location.x) y: \(location.y)")
			
			var xMod = 0
			var yMod = 0
			
			if location.y > 150 { yMod = -1 }
			else if location.y < -150   { yMod = 1 }
			else if location.x < 0   { xMod = -1 }
			else { xMod = 1 }
			
			var destination = currentStage.tileAtLocation(player.x + xMod, y: player.y + yMod - 1)
			
			if destination == tile.outside || destination == tile.wall {
			
			}
			else{
				player.move(xMod, yUpdate: yMod)
			}
			
			turn()
        }
    }
	
	func turn()
	{
		newDraw()
	}
   
    override func update(currentTime: CFTimeInterval) {
		
    }
}
