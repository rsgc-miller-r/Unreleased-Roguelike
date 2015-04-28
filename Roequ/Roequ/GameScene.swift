//
//  GameScene.swift
//  Roequ
//
//  Created by Devine Lu Linvega on 2015-04-27.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

import SpriteKit

let tileCountX:CGFloat = 32
let tileCountY:CGFloat = 32
var tileSize:CGFloat = 0

let typeOutside:Int = 1
let typeFloor:Int = 2
let typeBleed:Int = 3
let typeLimit:Int = 99

enum tile:UInt32 {
	case outside = 1
	case floor = 2
	case section = 3
	case limit = 99
}

class GameScene: SKScene {
    override func didMoveToView(view: SKView)
	{
		tileSize = self.frame.size.width/CGFloat(tileCountX)
		createWorld()
    }
	
	func generateRooms() -> Array<tile>
	{
		var testArray:Array = [tile.outside]
		
		var x:CGFloat = 0
		while( x < tileCountX * tileCountY ){
			testArray.append(tile.outside)
			x += 1
		}
		
		testArray = makeRooms(testArray)
		testArray = bleedRooms(testArray)
		
		
		
		
		// Bleed the rooms to the edges
		
		
		
		return testArray
	}
	
	func bleedRooms(targetMap:Array<tile>) -> Array<tile>
	{
		var updatedMap:Array = targetMap
		
		var index = 0
		while( index < targetMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			// Connect close rooms
			if( tileAtLocation(updatedMap, x: currentX, y: currentY) == tile.outside ){
				if( tileAtLocation(updatedMap, x: currentX+1, y: currentY) == tile.floor && tileAtLocation(updatedMap, x: currentX-1, y: currentY) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.section
				}
				if( tileAtLocation(updatedMap, x: currentX, y: currentY+1) == tile.floor && tileAtLocation(updatedMap, x: currentX, y: currentY-1) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.section
				}
			}
			// Expand to the edges
			if( tileAtLocation(updatedMap, x: currentX, y: currentY) == tile.outside ){
				if( tileAtLocation(updatedMap, x: currentX+1, y: currentY) == tile.floor && tileAtLocation(updatedMap, x: currentX-1, y: currentY) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.section
				}
				if( tileAtLocation(updatedMap, x: currentX, y: currentY+1) == tile.floor && tileAtLocation(updatedMap, x: currentX, y: currentY-1) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.section
				}
			}
			
			index += 1
		}
		
		return updatedMap
	}
	
	func makeRooms(targetMap:Array<tile>) -> Array<tile>
	{
		var updatedMap:Array = targetMap
		
		// Make the rooms
		var i:Int = 0
		while( i < 10000){
			
			let posX = CGFloat(arc4random_uniform(UInt32(tileCountX)))
			let posY = CGFloat(arc4random_uniform(UInt32(tileCountY)))
			let width = CGFloat(arc4random_uniform(10)) + 2
			let height = CGFloat(arc4random_uniform(10)) + 2
			
			// Don't create on edges
			if( posX == 0 ){ continue }
			if( posY == 0 ){ continue }
			if( posY + height >= tileCountY - 1 ){ continue }
			if( posX + width >= tileCountX - 1 ){ continue }
			
			let check = locateTileType(CGRectMake(posX-1,posY-1,width+2,height+2), targetMap: updatedMap, tileType: tile.floor)
			
			if check == nil {
				updatedMap = mapArea(CGRectMake(posX,posY,width,height),targetMap: updatedMap,tileType: tile.floor)
			}
			i += 1
		}
		
		return updatedMap
	}
	
	func locateTileType(section:CGRect, targetMap:Array<tile>, tileType:tile) -> CGPoint?
	{
		var index = 0
		while( index < targetMap.count ){
			
			let originX:Int = Int(section.origin.x)
			let originY:Int = Int(section.origin.y)
			let limitX:Int = originX + Int(section.size.width)
			let limitY:Int = originY + Int(section.size.height)
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			if targetMap[index] == tileType && currentX >= originX && currentX <= limitX && currentY >= originY && currentY <= limitY {
				return CGPoint(x: currentX, y: currentY)
			}
			
			index += 1
		}

		return nil
	}
	
	func mapArea(section:CGRect, targetMap:Array<tile>, tileType:tile) -> Array<tile>
	{
		var updatedMap:Array = targetMap
		
		var index = 0
		while( index < updatedMap.count ){

			let originX:Int = Int(section.origin.x)
			let originY:Int = Int(section.origin.y)
			let limitX:Int = originX + Int(section.size.width)
			let limitY:Int = originY + Int(section.size.height)
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			if( currentX >= originX && currentX <= limitX && currentY >= originY && currentY <= limitY ){ updatedMap[index] = tile.floor }
			
			index += 1
		}
		
		return updatedMap
	}
	
	func createWorld()
	{
		let testArray = generateRooms()
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
				else{
					sprite.color = UIColor.whiteColor()
				}
				
				self.addChild(sprite)
				y += 1
			}
			x += 1
		}
	}
	
	func tileAtLocation(targetMap:Array<tile>,x:Int,y:Int) -> tile
	{
		let index = indexAtLocation(x,y: y)
		
		if ( index >= 0 && index <= Int(tileCountX) * Int(tileCountY) ){
			return targetMap[index]
		}
		
		return tile.limit
	}
	
	func indexAtLocation( x:Int,y:Int ) -> Int
	{
		return (y * Int(tileCountX)) + x
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
