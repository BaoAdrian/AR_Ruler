//
//  ViewController.swift
//  ARRuler
//
//  Created by Adrian Bao on 7/18/18.
//  Copyright © 2018 Adrian Bao. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    let InchesInOneMeter : Float = 39.3701

    var dotNodeArray = [SCNNode]()
    var textNode = SCNNode()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // If user selects a third location, app removes the two previous dots and starts a new measurement
        if dotNodeArray.count >= 2 {
            for dot in dotNodeArray {
                dot.removeFromParentNode()
            }
            dotNodeArray = [SCNNode]() // Reinitialize
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            // Add placemarker
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            } else {
                // no valid location exists
            }
        } else {
            // not valid touch exists
        }
        
    }
    
    func addDot(at hitResult: ARHitTestResult) {
        
        let dotGeomety = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        dotGeomety.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeomety)
        
        // Assign position using hitResult
        dotNode.position = SCNVector3(
            x: hitResult.worldTransform.columns.3.x,
            y: hitResult.worldTransform.columns.3.y,
            z: hitResult.worldTransform.columns.3.z
        )
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodeArray.append(dotNode)
        
        if dotNodeArray.count >= 2 {
            calculate()
        }
        
    }
    
    // Calculate distance between two nodes
    func calculate() {
        let start = dotNodeArray[0]
        let end = dotNodeArray[1]
        
//        print(start.position)
//        print(end.position)
        
        // distance = √((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
        var distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        ) * InchesInOneMeter
        
        // Round the decimal
        distance = round(distance*1000)/1000
        
        updateText(text: "\(distance)" + " in.", atPosition: end.position)
        
    }
    
    func updateText(text: String, atPosition position: SCNVector3) {
        
        // Clears any previous text
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(x: position.x, y: position.y + 0.01, z: position.z)
        
        textNode.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.005) // Scaling text down to 1% of original size
        
        // Orientation of text determined on position of camera
        if let camera = sceneView.pointOfView {
            textNode.orientation = camera.orientation
        }
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
}





















