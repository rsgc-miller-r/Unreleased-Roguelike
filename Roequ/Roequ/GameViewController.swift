//
//  GameViewController.swift
//  Roequ
//
//  Created by Devine Lu Linvega on 2015-04-27.
//  Copyright (c) 2015 Devine Lu Linvega. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController
{
	var sceneTest:GameScene!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		screenSize = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
			sceneTest = scene
			
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
			scene.scaleMode = .AspectFill
			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			scene.size = skView.bounds.size
			scene.backgroundColor = UIColor(white: 0, alpha: 1)
			
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
		return true
    }
	
	@IBAction func fireButton(sender: AnyObject) {
		println("FIRE")
		
		events.addEvent(player.x, y: player.y-1, type: eventType.bullet, dir: player.dir)
		sceneTest.turn()
	}
	
	
}
