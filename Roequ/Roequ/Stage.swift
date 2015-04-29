//
//  Stage.swift
//  Roequ
//
//  Created by Devine Lu Linvega on 2015-04-29.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

import Foundation
import SpriteKit

class Stage
{
	var activeStage:Array<tile> = []
	
	init()
	{
		generate()
	}
	
	func generate()
	{
		
		generateBlankStage()
		generatePathways()
		generatePathwaysBleed()
		generateRoomsBleed()
		generateRoomsFill()
		generateRoomsTrim()
		
		removeFocus()
		
		addSpawn()
		addExit()
		addWalls()
		addPickup()
		
		/*
		
		// Level size
		var index = 0
		var mapSize = 0
		while( index < updatedMap.count ){
			if( updatedMap[index] == tile.floor ){
				mapSize += 1
			}
			index += 1
		}
		println(mapSize)
		
		if( mapSize < 200 ){
			updatedMap = generate()
		}
		if (find(updatedMap, tile.pickup) == nil) {
			updatedMap = generate()
		}
*/

	}
	
	func generateBlankStage()
	{
		var updatedMap:Array = [tile.outside]
		
		var x:CGFloat = 0
		while( x < tileCountX * tileCountY ){
			updatedMap.append(tile.outside)
			x += 1
		}
		
		return activeStage = updatedMap
	}
	
	func generatePathways()
	{
		var updatedMap:Array = activeStage
		
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
		
		activeStage = updatedMap
	}
	
	func generatePathwaysBleed()
	{
		var updatedMap:Array = activeStage
		
		var index = 0
		while( index < updatedMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			// Connect close rooms
			if( tileAtLocation( currentX, y: currentY) == tile.outside ){
				if( tileAtLocation( currentX+1, y: currentY) == tile.floor && tileAtLocation(  currentX-1, y: currentY) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
				}
				if( tileAtLocation( currentX, y: currentY+1) == tile.floor && tileAtLocation(  currentX, y: currentY-1) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
				}
			}
			// Expand to the edges
			if( tileAtLocation( currentX, y: currentY) == tile.outside ){
				if( tileAtLocation( currentX+3, y: currentY) == tile.limit && currentX == Int(tileCountX) - 2 && tileAtLocation(  currentX-1, y: currentY) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
				}
				if( tileAtLocation( currentX-3, y: currentY) == tile.limit && currentX == 1 && tileAtLocation(  currentX+1, y: currentY) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
				}
				if( tileAtLocation( currentX, y: currentY+3) == tile.limit && currentY == Int(tileCountY) - 2 && tileAtLocation(  currentX, y: currentY-1) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
				}
				if( tileAtLocation( currentX, y: currentY-3) == tile.limit && currentY == 1 && tileAtLocation(  currentX, y: currentY+1) == tile.floor ){
					updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
				}
			}
			
			index += 1
		}
		
		activeStage = updatedMap
	}
	
	func generateRoomsBleed()
	{
		var updatedMap:Array = activeStage
		
		// Collapse Walls
		var index = 0
		while( index < updatedMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			if( tileAtLocation( currentX, y: currentY) == tile.outside && tileAtLocation(  currentX+1, y: currentY) == tile.outside && tileAtLocation(  currentX+2, y: currentY) == tile.floor && tileAtLocation(  currentX-2, y: currentY) == tile.floor ){
				updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
				updatedMap[indexAtLocation(currentX+1, y: currentY)] = tile.floor
			}
			
			index += 1
		}
		
		// Remove spikes
		index = 0
		while( index < updatedMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			if( tileAtLocation( currentX, y: currentY) == tile.outside && tileAtLocation(  currentX, y: currentY+1) == tile.floor && tileAtLocation(  currentX, y: currentY-1) == tile.floor ){
				updatedMap[indexAtLocation(currentX, y: currentY)] = tile.floor
			}
			
			index += 1
		}
		
		activeStage = updatedMap
	}
	
	func generateRoomsFill()
	{
		var updatedMap:Array = activeStage
		
		var index = 0
		while( index < updatedMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			// Find a floor block and cover it in focus
			if( updatedMap[index] == tile.floor ){
				
				updatedMap = mapArea(CGRectMake(CGFloat(currentX),CGFloat(currentY),0,0),targetMap: updatedMap,tileType: tile.focus)
				
				var completed = 0
				while( completed < 50 ){
					var subIndex = 0
					while( subIndex < updatedMap.count ){
						let focusX:Int = Int(subIndex % Int(tileCountX))
						let focusY:Int = Int(subIndex / Int(tileCountY))
						
						if( updatedMap[subIndex] == tile.focus && updatedMap[indexAtLocation(focusX+1, y: focusY)] == tile.floor ){
							updatedMap[indexAtLocation(focusX+1, y: focusY)] = tile.focus
						}
						if( updatedMap[subIndex] == tile.focus && updatedMap[indexAtLocation(focusX-1, y: focusY)] == tile.floor ){
							updatedMap[indexAtLocation(focusX-1, y: focusY)] = tile.focus
						}
						if( updatedMap[subIndex] == tile.focus && tileAtLocation( focusX, y: focusY+1) == tile.floor ){
							updatedMap[indexAtLocation(focusX, y: focusY+1)] = tile.focus
						}
						if( updatedMap[subIndex] == tile.focus && tileAtLocation( focusX, y: focusY-1) == tile.floor ){
							updatedMap[indexAtLocation(focusX, y: focusY-1)] = tile.focus
						}
						subIndex += 1
					}
					completed += 1
				}
				break
			}
			index += 1
		}
		
		activeStage = updatedMap
	}
	
	func generateRoomsTrim()
	{
		var updatedMap:Array = activeStage
		
		// Collapse Walls
		var index = 0
		while( index < updatedMap.count ){
			
			if updatedMap[index] == tile.floor {
				updatedMap[index] = tile.outside
			}
			
			index += 1
		}
		
		activeStage = updatedMap
	}
	
	// MARK: Add Events -
	
	func addWalls()
	{
		var updatedMap:Array = activeStage
		
		// Collapse Walls
		var index = 0
		while( index < updatedMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			// Vertical Sections
			if tileAtLocation(  currentX, y: currentY) == tile.outside && tileAtLocation(  currentX-1, y: currentY) == tile.floor && tileAtLocation(  currentX+2, y: currentY+1) == tile.floor && tileAtLocation(  currentX+3, y: currentY+1) == tile.floor {
				var check = 1
				while check < 30 {
					if updatedMap[indexAtLocation(currentX, y: currentY+check)] == tile.floor {
						updatedMap[indexAtLocation(currentX, y: currentY+check)] = tile.section
					}
					else {
						break
					}
					check += 1
				}
			}
			
			index += 1
		}
		activeStage = updatedMap
	}
	
	func addExit()
	{
		var updatedMap:Array = activeStage
		
		var exitX:Int = 0
		var exitY:Int = 0
		var furthestDistance:Int = 0
		
		// Todo: regenerate if there are no entrance
		
		var spawnIndex = find(updatedMap, tile.spawn)!
		let spawnX:Int = Int(spawnIndex % Int(tileCountX))
		let spawnY:Int = Int(spawnIndex / Int(tileCountY))
		
		// Collapse Walls
		var index = 0
		while( index < updatedMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			// tileAtLocation(  currentX, y: currentY) == tile.floor
			
			if abs(spawnX - currentX) + abs(spawnY - currentY) > furthestDistance && tileAtLocation(  currentX, y: currentY) == tile.floor && tileAtLocation(  currentX+1, y: currentY) == tile.floor && tileAtLocation(  currentX-1, y: currentY) == tile.floor && tileAtLocation(  currentX, y: currentY+1) == tile.outside && tileAtLocation(  currentX+1, y: currentY+1) == tile.outside && tileAtLocation(  currentX-1, y: currentY+1) == tile.outside {
				furthestDistance = abs(spawnX - currentX) + abs(spawnY - currentY)
				exitX = currentX
				exitY = currentY+1
			}
			
			index += 1
		}
		
		updatedMap[indexAtLocation(exitX, y: exitY)] = tile.exit
		println("Distance: \(furthestDistance) \(exitX) - \(exitY)")
		activeStage = updatedMap
	}
	
	func addSpawn()
	{
		var updatedMap:Array = activeStage
		
		// Collapse Walls
		var spawnCreated = 0
		while( spawnCreated != 1 ){
			
			let randomIndex = Int(arc4random_uniform(UInt32(tileCountX*tileCountY)))
			let currentX:Int = Int(randomIndex % Int(tileCountX))
			let currentY:Int = Int(randomIndex / Int(tileCountY))
			
			if tileAtLocation(  currentX, y: currentY) == tile.floor && tileAtLocation(  currentX-1, y: currentY) == tile.floor && tileAtLocation(  currentX+1, y: currentY) == tile.floor && tileAtLocation(  currentX, y: currentY-1) == tile.outside && tileAtLocation(  currentX+1, y: currentY-1) == tile.outside && tileAtLocation(  currentX-1, y: currentY-1) == tile.outside {
				updatedMap[indexAtLocation(currentX, y: currentY-1)] = tile.spawn
				spawnCreated = 1
			}
		}
		
		activeStage = updatedMap
	}
	
	func addPickup()
	{
		var updatedMap:Array = activeStage
		
		// Collapse Walls
		var index = 0
		while( index < updatedMap.count ){
			
			let currentX:Int = Int(index % Int(tileCountX))
			let currentY:Int = Int(index / Int(tileCountY))
			
			let findFloor = locateTileType(CGRectMake(CGFloat(currentX),CGFloat(currentY),4,4), targetMap: updatedMap, tileType: tile.floor)
			
			if findFloor == nil && CGFloat(currentX) + 2 < tileCountX - 1 && CGFloat(currentY) + 2 < tileCountY - 1 && CGFloat(currentX) < tileCountX - 5 {
				
				// Bottom
				if indexAtLocation(currentX+2, y: currentY) < Int(tileCountX * tileCountY) && indexAtLocation(currentX+2, y: currentY-1) > 0 && tileAtLocation(  currentX+2, y: currentY-1) == tile.floor {
					updatedMap = mapArea(CGRectMake(CGFloat(currentX)+1,CGFloat(currentY)+1,2,2),targetMap: updatedMap,tileType: tile.floor)
					updatedMap[indexAtLocation(currentX+2, y: currentY)] = tile.section
					updatedMap[indexAtLocation(currentX+2, y: currentY+2)] = tile.pickup
				}
					// Right
				else if indexAtLocation(currentX+4, y: currentY+2) < Int(tileCountX * tileCountY) && indexAtLocation(currentX+4, y: currentY+2) > 0 && tileAtLocation(  currentX+5, y: currentY+2) == tile.floor {
					updatedMap = mapArea(CGRectMake(CGFloat(currentX)+1,CGFloat(currentY)+1,2,2),targetMap: updatedMap,tileType: tile.floor)
					updatedMap[indexAtLocation(currentX+4, y: currentY+2)] = tile.section
					updatedMap[indexAtLocation(currentX+2, y: currentY+2)] = tile.pickup
				}
					// Top
				else if indexAtLocation(currentX+2, y: currentY+4) < Int(tileCountX * tileCountY) && indexAtLocation(currentX+2, y: currentY+4) > 0 && tileAtLocation(  currentX+2, y: currentY+5) == tile.floor {
					updatedMap = mapArea(CGRectMake(CGFloat(currentX)+1,CGFloat(currentY)+1,2,2),targetMap: updatedMap,tileType: tile.floor)
					updatedMap[indexAtLocation(currentX+2, y: currentY+4)] = tile.section
					updatedMap[indexAtLocation(currentX+2, y: currentY+2)] = tile.pickup
				}
					
					// Left
				else if indexAtLocation(currentX, y: currentY+2) < Int(tileCountX * tileCountY) && indexAtLocation(currentX, y: currentY+2) > 0 && tileAtLocation(  currentX-1, y: currentY+2) == tile.floor {
					updatedMap = mapArea(CGRectMake(CGFloat(currentX)+1,CGFloat(currentY)+1,2,2),targetMap: updatedMap,tileType: tile.floor)
					updatedMap[indexAtLocation(currentX, y: currentY+2)] = tile.section
					updatedMap[indexAtLocation(currentX+2, y: currentY+2)] = tile.pickup
				}
				
				break
			}
			
			index += 1
		}
		activeStage = updatedMap
	}
	
	// MARK: Tools -
	
	func removeFocus()
	{
		var updatedMap:Array = activeStage
		var index = 0
		while( index < updatedMap.count ){
			
			if updatedMap[index] == tile.focus {
				updatedMap[index] = tile.floor
			}
			index += 1
		}
		activeStage = updatedMap
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
			
			if( currentX >= originX && currentX <= limitX && currentY >= originY && currentY <= limitY ){ updatedMap[index] = tileType }
			
			index += 1
		}
		
		return updatedMap
	}
	
	func tileAtLocation(x:Int,y:Int) -> tile
	{
		let index = indexAtLocation(x,y: y)
		
		if( x < 0 ){ return tile.limit }
		if( x > Int(tileCountX) ){ return tile.limit }
		if( y < 0 ){ return tile.limit }
		if(y > Int(tileCountY) ){ return tile.limit }
		
		if ( index >= 0 && index <= Int(tileCountX) * Int(tileCountY) ){
			return activeStage[index]
		}
		
		return tile.limit
	}
	
	func indexAtLocation( x:Int,y:Int ) -> Int
	{
		return (y * Int(tileCountX)) + x
	}
}