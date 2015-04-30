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
	
	init(spawnX:Int,spawnY:Int,newType:eventType,newDir:direction)
	{
		x = spawnX
		y = spawnY
		type = newType
		dir = newDir
	}
	
	func generate()
	{
		
	}
	
	func move(dir:direction)
	{
		if dir == direction.top { y += 1 }
		if dir == direction.right { x += 1 }
		if dir == direction.down { y -= 1 }
		if dir == direction.left { x -= 1 }
	}
	
}