//
//  ViewController.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 9/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit

enum ButtonDirection: Int {
    case Left = 0, Right = 1
}

class ViewController: UIViewController {

    var stateMachine: LaneStateMachine!

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = SKView(frame: view.frame)

        var scene: MainScene?

        if let savedSceneData = NSUserDefaults.standardUserDefaults().objectForKey("currentScene") as? NSData,
           let savedScene = NSKeyedUnarchiver.unarchiveObjectWithData(savedSceneData) as? MainScene {
            scene = savedScene

        } else if let url = NSBundle.mainBundle().URLForResource("MainScene", withExtension: "sks"),
                  let newSceneData = NSData(contentsOfURL: url),
                  let newScene = NSKeyedUnarchiver.unarchiveObjectWithData(newSceneData) as? MainScene {
            scene = newScene
        }

        skView.presentScene(scene)
        view.insertSubview(skView, atIndex: 0)

        let left = LeftLane(player: scene!.player)
        let middle = MiddleLane(player: scene!.player)
        let right = RightLane(player: scene!.player)

        stateMachine = LaneStateMachine(states: [left, middle, right])
        stateMachine?.enterState(MiddleLane)
    }

    @IBAction func didPressButton(sender: UIButton) {
        switch sender.tag {
        case ButtonDirection.Left.rawValue:
            switch stateMachine.currentState {
            case is RightLane:
                stateMachine.enterState(MiddleLane)
            case is MiddleLane:
                stateMachine.enterState(LeftLane)
            default:
                break
            }
        case ButtonDirection.Right.rawValue:
            switch stateMachine.currentState {
            case is LeftLane:
                stateMachine.enterState(MiddleLane)
            case is MiddleLane:
                stateMachine.enterState(RightLane)
            default:
                break
            }
        default:
            break
        }
    }

}
