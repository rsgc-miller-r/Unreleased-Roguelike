//
//  Events.swift
//  Roequ
//
//  Created by Devine Lu Linvega on 2015-04-30.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

import Foundation
import SpriteKit

class Events
{
	var activeEvents:Array<Event> = []
	
	init()
	{
		generate()
	}
	
	func generate()
	{
		
	}
	
	func addEvent(x:Int,y:Int,type:eventType,dir:direction)
	{
		let test = Event(spawnX: x, spawnY: y,type:type,dir:dir)
		activeEvents.append(test)
		
		println("Events: \(activeEvents)")
	}
	
	func eventAtLocation(x:Int,y:Int) -> Event?
	{
		for (index, element) in enumerate(activeEvents) {
			
			if element.x == x && element.y == y {
				return element
			}
		}
		return nil
	}
}