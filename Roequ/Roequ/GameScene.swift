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
	case bullet = 11
	case limit = 99
}

enum eventType:UInt32 {
	case bullet = 1
}
enum direction:UInt32 {
	case top = 1
	case right = 2
	case down = 3
	case left = 4
	case topleft = 5
	case topright = 6
	case downleft = 7
	case downright = 8
}

let tileCountX:CGFloat = 39
let tileCountY:CGFloat = 39
var tileSizeX:CGFloat = 0
var tileSizeY:CGFloat = 0

var events:Events!
var currentStage:Stage!
var player:Player!

var screenSize:CGRect = CGRectMake(0, 0, 0, 0)

var renderCanvas = SKSpriteNode()
let renderScale:CGFloat = 2
let renderSize = CGSizeMake(screenSize.width/renderScale, screenSize.height/renderScale)

class GameScene: SKScene {
	
    override func didMoveToView(view: SKView)
	{
		tileSizeX = floor(self.frame.size.width/CGFloat(tileCountX)) + 1
		tileSizeY = floor(tileSizeX * 1.5)
		
		tileSizeX = 7
		tileSizeY = 11
		
		currentStage = Stage()
		events = Events()
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
				let currentIndex = currentStage.indexAtLocation(x + horizontalOffset, y: y + verticalOffset)
				let currentPosition = CGPoint(x: tileSizeX * CGFloat(x), y: tileSizeY * CGFloat(y) )
				
				let targetEvent = events.eventAtLocation(x + horizontalOffset, y: y + verticalOffset)
				
				if targetEvent?.sprite == tile.bullet { spriteBullet(context, index: currentIndex, position: currentPosition, event:targetEvent ) }
				else if x == Int(horizontalTiles/2) && y == Int(verticalTiles/2) { spritePlayer(context, index: currentIndex, position: currentPosition) }
				else if( targetTile == tile.section ){ spriteSection(context, index: currentIndex, position: currentPosition) }
				else if( targetTile == tile.limit ){ spriteLimit(context, index: currentIndex, position: currentPosition) }
				else if( targetTile == tile.wall ){ spriteWall(context, index: currentIndex, position: currentPosition) }
				else if( targetTile == tile.floor ){ spriteFloor(context, index: currentIndex, position: currentPosition) }
				else if( targetTile == tile.outside ){ spriteOutside(context, index: currentIndex, position: currentPosition) }
				else {
					spriteMissing(context, index: currentIndex, position: currentPosition)
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
	
	// MARK: Sprites -
	
	func spriteBullet(context:CGContextRef, index:Int, position:CGPoint, event:Event?)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		
		let center:CGPoint = CGPoint(x: position.x + 4, y: position.y + 5)
		var color = UIColor.yellowColor()
		
		if event?.life == 3 { color = UIColor.yellowColor() }
		else if event?.life == 2 { color = UIColor.orangeColor() }
		else if event?.life == 1 { color = UIColor.redColor() }
		else if event?.life == 0 { color = UIColor.grayColor() }
		else { color = UIColor.whiteColor() }
		
		if event?.dir == direction.top || event?.dir == direction.down {
			drawLine(context, origin: CGPoint(x: center.x, y: center.y - 2), destination: CGPoint(x: center.x, y: center.y + 2), color: color )
		}
		if event?.dir == direction.left || event?.dir == direction.right{
			drawLine(context, origin: CGPoint(x: center.x - 2, y: center.y), destination: CGPoint(x: center.x + 2, y: center.y), color: color )
		}
		if event?.dir == direction.downleft {
			drawLine(context, origin: center, destination: CGPoint(x: center.x + 2, y: center.y), color: color )
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 2), color: color )
		}
		if event?.dir == direction.downright {
			drawLine(context, origin: center, destination: CGPoint(x: center.x - 2, y: center.y), color: color )
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 2), color: color )
		}
		if event?.dir == direction.topleft {
			drawLine(context, origin: center, destination: CGPoint(x: center.x + 2, y: center.y), color: color )
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 2), color: color )
		}
		if event?.dir == direction.topright {
			drawLine(context, origin: center, destination: CGPoint(x: center.x - 2, y: center.y), color: color )
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 2), color: color )
		}
	}

	func spriteMissing(context:CGContextRef, index:Int, position:CGPoint)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		
		let center:CGPoint = CGPoint(x: position.x + tileSizeX/2, y: position.y + tileSizeY/2)
		let color = UIColor.redColor()
		
		drawLine(context, origin: CGPoint(x: center.x - tileSizeX/4, y: center.y + tileSizeX/4), destination: CGPoint(x: center.x + tileSizeX/4, y: center.y + tileSizeX/4), color: color )
	}
	
	
	func spriteOutside(context:CGContextRef, index:Int, position:CGPoint)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		let color = UIColor(white: 0.2, alpha: 1)
		
		let center:CGPoint = CGPoint(x: position.x + tileSizeX/2, y: position.y + tileSizeY/2)
		
		if currentStage.tileAtLocation(currentX+1, y: currentY) == tile.outside {
			drawLine(context, origin: center, destination: CGPoint(x: center.x + tileSizeX/2, y: center.y), color: color )
		}
		if currentStage.tileAtLocation(currentX-1, y: currentY) == tile.outside {
			drawLine(context, origin: center, destination: CGPoint(x: center.x - tileSizeX/2, y: center.y), color: color )
		}
		if currentStage.tileAtLocation(currentX, y: currentY+1) == tile.outside {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + tileSizeX/2), color: color )
		}
		if currentStage.tileAtLocation(currentX, y: currentY-1) == tile.outside {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - tileSizeX/2), color: color )
		}
	}
	
	func spriteFloor(context:CGContextRef, index:Int, position:CGPoint)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		
		let center:CGPoint = CGPoint(x: position.x + tileSizeX/2, y: position.y + tileSizeY/2)
		
		drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 0.1), color: UIColor(white: 0.2, alpha: 1) )
		drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 0.1), color: UIColor(white: 0.2, alpha: 1) )
		drawLine(context, origin: center, destination: CGPoint(x: center.x - 0.1, y: center.y), color: UIColor(white: 0.2, alpha: 1) )
		drawLine(context, origin: center, destination: CGPoint(x: center.x + 0.1, y: center.y), color: UIColor(white: 0.2, alpha: 1) )
		
	}
	
	func spritePlayer(context:CGContextRef, index:Int, position:CGPoint)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		let color = UIColor.orangeColor()
		
		let center:CGPoint = CGPoint(x: position.x + 4, y: position.y + 6)
		
		if player.dir == direction.down { drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 2), color: color ) }
		if player.dir == direction.top { drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 2), color: color ) }
		if player.dir == direction.right { drawLine(context, origin: center, destination: CGPoint(x: center.x + 2, y: center.y), color: color ) }
		if player.dir == direction.left { drawLine(context, origin: center, destination: CGPoint(x: center.x - 2, y: center.y), color: color ) }
		
		drawLine(context, origin: CGPoint(x: center.x - 2, y: center.y - 2), destination: CGPoint(x: center.x + 2, y: center.y - 2), color: color )
		drawLine(context, origin: CGPoint(x: center.x - 2, y: center.y + 2), destination: CGPoint(x: center.x + 2, y: center.y + 2), color: color )
		
		drawLine(context, origin: CGPoint(x: center.x - 2, y: center.y - 2), destination: CGPoint(x: center.x - 2, y: center.y + 2), color: color )
		drawLine(context, origin: CGPoint(x: center.x + 2, y: center.y - 2), destination: CGPoint(x: center.x + 2, y: center.y + 2), color: color )
		
		drawLine(context, origin: CGPoint(x: center.x - 2, y: center.y + 4), destination: CGPoint(x: center.x + 2, y: center.y + 4), color: UIColor.grayColor() )
		
	}
	
	func spriteLimit(context:CGContextRef, index:Int, position:CGPoint)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		let color = UIColor(white: 0.2, alpha: 1)
		
		let center:CGPoint = CGPoint(x: position.x + tileSizeX/2, y: position.y + tileSizeY/2)
		
		drawLine(context, origin: CGPoint(x: center.x - tileSizeX/4, y: center.y + tileSizeX/4), destination: CGPoint(x: center.x + tileSizeX/4, y: center.y + tileSizeX/4), color: color )
		drawLine(context, origin: CGPoint(x: center.x - tileSizeX/4, y: center.y - tileSizeX/4), destination: CGPoint(x: center.x + tileSizeX/4, y: center.y - tileSizeX/4), color: color )
	}
	
	func spriteSection(context:CGContextRef, index:Int, position:CGPoint)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		
		let center:CGPoint = CGPoint(x: position.x + 4, y: position.y + 5)
		let color = UIColor(white: 0.2, alpha: 1)
		
		if currentStage.tileAtLocation(currentX+1, y: currentY) == tile.section {
			drawLine(context, origin: center, destination: CGPoint(x: center.x + 2, y: center.y), color: color )
		}
		if currentStage.tileAtLocation(currentX-1, y: currentY) == tile.section {
			drawLine(context, origin: center, destination: CGPoint(x: center.x - 2, y: center.y), color: color )
		}
		if currentStage.tileAtLocation(currentX, y: currentY+1) == tile.section {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 2), color: color )
		}
		if currentStage.tileAtLocation(currentX, y: currentY-1) == tile.section {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 2), color: color )
		}
		if currentStage.tileAtLocation(currentX, y: currentY-1) == tile.floor && currentStage.tileAtLocation(currentX, y: currentY+1) == tile.floor && currentStage.tileAtLocation(currentX+1, y: currentY) == tile.floor && currentStage.tileAtLocation(currentX-1, y: currentY) == tile.floor {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 2), color: color )
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 2), color: color )
			drawLine(context, origin: center, destination: CGPoint(x: center.x - 2, y: center.y), color: color )
			drawLine(context, origin: center, destination: CGPoint(x: center.x + 2, y: center.y), color: color )
		}
	}
	
	func spriteWall(context:CGContextRef, index:Int, position:CGPoint)
	{
		let currentX:Int = Int(index % Int(tileCountX))
		let currentY:Int = Int(index / Int(tileCountY))
		
		let center:CGPoint = CGPoint(x: position.x + 4, y: position.y + 6)
		
		if currentStage.tileAtLocation(currentX+1, y: currentY) == tile.wall {
			drawLine(context, origin: center, destination: CGPoint(x: center.x + 3, y: center.y), color: UIColor.whiteColor() )
		}
		if currentStage.tileAtLocation(currentX-1, y: currentY) == tile.wall {
			drawLine(context, origin: center, destination: CGPoint(x: center.x - 3, y: center.y), color: UIColor.whiteColor() )
		}
		if currentStage.tileAtLocation(currentX, y: currentY+1) == tile.wall {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 5), color: UIColor.whiteColor() )
		}
		if currentStage.tileAtLocation(currentX, y: currentY-1) == tile.wall {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 5), color: UIColor.whiteColor() )
		}
		if currentStage.tileAtLocation(currentX, y: currentY-1) == tile.floor && currentStage.tileAtLocation(currentX, y: currentY+1) == tile.floor && currentStage.tileAtLocation(currentX+1, y: currentY) == tile.floor && currentStage.tileAtLocation(currentX-1, y: currentY) == tile.floor {
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y - 5), color: UIColor.whiteColor() )
			drawLine(context, origin: center, destination: CGPoint(x: center.x, y: center.y + 5), color: UIColor.whiteColor() )
			drawLine(context, origin: center, destination: CGPoint(x: center.x - 3, y: center.y), color: UIColor.whiteColor() )
			drawLine(context, origin: center, destination: CGPoint(x: center.x + 3, y: center.y), color: UIColor.whiteColor() )
		}
	}
	
	// MARK: Tools -
	
	func drawLine(context:CGContextRef,origin:CGPoint,destination:CGPoint,color:UIColor)
	{
		CGContextMoveToPoint(context, origin.x,origin.y)
		CGContextAddLineToPoint(context, destination.x, destination.y)
		CGContextSetStrokeColorWithColor(context, color.CGColor)
		CGContextSetLineWidth(context,1)
		CGContextStrokePath(context)
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
			
			if location.y > 150 { yMod = -1; player.dir = direction.down }
			else if location.y < -150   { yMod = 1; player.dir = direction.top }
			else if location.x < 0   { xMod = -1; player.dir = direction.left }
			else { xMod = 1; player.dir = direction.right }
			
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
		println("-   TURN | Normal")

		for (index, event) in enumerate(events.activeEvents) {
			event.collide(currentStage.tileAtLocation(event.x, y: event.y))
			if event.type == eventType.bullet { event.move(event.dir) }
		}
		
		newDraw()
		
		// Bullet turn
		var timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("turnSpecial"), userInfo: nil, repeats: false)
		removeDeadEvents()
	}
	
	func turnSpecial()
	{
		println("-   TURN | Special")
		
		for (index, event) in enumerate(events.activeEvents) {
			println("Collided with \(currentStage.tileAtLocation(event.x, y: event.y).rawValue)")
			event.collide(currentStage.tileAtLocation(event.x, y: event.y))
			if event.type == eventType.bullet { event.move(event.dir) }
		}
		
		newDraw()
		removeDeadEvents()
	}
	
	func removeDeadEvents()
	{
		for (index, event) in enumerate(events.activeEvents) {
			if event.life < 0 { events.activeEvents.removeAtIndex(index) }
			break
		}
	}
   
    override func update(currentTime: CFTimeInterval) {
		
    }
}
