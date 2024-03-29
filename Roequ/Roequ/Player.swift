//
//  Player.swift
//  Roequ
//
//  Created by Devine Lu Linvega on 2015-04-29.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

import Foundation
import SpriteKit

class Player
{
	var position:CGPoint = CGPoint()
	var x:Int = 0
	var y:Int = 0
	var dir:direction!
	
	init(spawn:CGPoint)
	{
		println("+ PLAYER | Created at: \(spawn)")
		position = spawn
		dir = direction.top
		x = Int(position.x)
		y = Int(position.y)
	}
	
	func generate()
	{
		
	}
	
	func move(xUpdate:Int,yUpdate:Int)
	{
		x += xUpdate
		y += yUpdate
	}
}