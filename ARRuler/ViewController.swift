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

    var dotNodeArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
        
        print(start.position)
        print(end.position)
        
        // distance = √((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        
        print(distance)
        
    }
    
    
}





















