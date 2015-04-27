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

class GameScene: SKScene {
    override func didMoveToView(view: SKView)
	{
		tileSize = self.frame.size.width/CGFloat(tileCountX)
		
		createWorld()
    }
	
	func generateRooms() -> Array<Int>
	{
		var testArray:Array = [0]
		
		var x:CGFloat = 0
		while( x < tileCountX * tileCountY ){
			testArray.append(1)
			x += 1
		}
		
		testArray = mapArea(CGRectMake(5, 5,10, 7),targetMap: testArray)
		
		return testArray
	}
	
	func mapArea(section:CGRect, targetMap:Array<Int>) -> Array<Int>
	{
		var updatedMap:Array = targetMap
		
		var index = 0
		while( index < updatedMap.count ){
			
			let origin:Int = Int(section.origin.x) + Int(section.origin.y * tileCountY)
			let originX:Int = Int(section.origin.x)
			let originY:Int = Int(section.origin.y)
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			println(currentX)
			println(currentY)
			
			let limitRight = origin + Int(section.size.width)
			let limitLeft = origin
			let limitTop = 20
			
			
			if( currentX == ){
				
				updatedMap[index] = 2
			}
			
			
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
				if( testArray[lookup] == 1 ){
					sprite.color = UIColor.blackColor()
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
