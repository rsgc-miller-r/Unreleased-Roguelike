//
//  Event.swift
//  Roequ
//
//  Created by Devine Lu Linvega on 2015-04-30.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

import Foundation
import SpriteKit

class Event
{
	var x:Int = 0
	var y:Int = 0
	var type:eventType!
	var dir:direction!
	var sprite:tile!
	var life:Int
	
	init(spawnX:Int,spawnY:Int,newType:eventType,newDir:direction)
	{
		x = spawnX
		y = spawnY
		type = newType
		dir = newDir
		life = 20
		
		if newType == eventType.bullet {
			sprite = tile.bullet
		}
	}
	
	func generate()
	{
		
	}
	
	func collide(collider:tile)
	{
		if( type == eventType.bullet ){
			if collider == tile.wall || collider == tile.outside {
				if dir == direction.top { dir = arc4random_uniform(2) == 1 ? direction.downleft : direction.downright }
				else if dir == direction.right { dir = arc4random_uniform(2) == 1 ? direction.topleft : direction.downleft }
				else if dir == direction.down { dir = arc4random_uniform(2) == 1 ? direction.topleft : direction.topright }
				else if dir == direction.left { dir = arc4random_uniform(2) == 1 ? direction.topright : direction.downright }
				else if dir == direction.downright { dir = arc4random_uniform(2) == 1 ? direction.left : direction.top }
				else if dir == direction.downleft { dir = arc4random_uniform(2) == 1 ? direction.right : direction.top }
				else if dir == direction.topright { dir = arc4random_uniform(2) == 1 ? direction.left : direction.down }
				else if dir == direction.topleft { dir = arc4random_uniform(2) == 1 ? direction.right : direction.down }
			}
		}
	}
	
	func move(dir:direction)
	{
		if dir == direction.top { y += 1 }
		if dir == direction.right { x += 1 }
		if dir == direction.down { y -= 1 }
		if dir == direction.left { x -= 1 }
		if dir == direction.topleft { x -= 1; y += 1}
		if dir == direction.topright { x += 1; y += 1}
		if dir == direction.downleft { x -= 1; y -= 1}
		if dir == direction.downright { x += 1; y -= 1}
		
		life -= 1
	}
	
}