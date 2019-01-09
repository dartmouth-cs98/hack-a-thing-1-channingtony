//
//  ViewController.swift
//  ChanningTony
//
//  Created by Alex Chan and Tony DiPadova on 1/8/19.
//  Copyright © 2019 cs98. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    
    // Naming SCNNodes
    let floorNodeName = "FloorNode"
    
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        tap.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer){
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty{
            addFurniture(hitTestResult: hitTest.first!)
            print("Touched on the plane")
        }
        else{
            print("Not a plane")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // For plane detection
        config.planeDetection = .horizontal
        addTapGesture()

        sceneView.session.run(config)
        sceneView.delegate = self

    }
    
    
    func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))) // create a plane rooted to the anchor
        
        floorNode.position=SCNVector3(anchor.center.x,0,anchor.center.z) // set plane position
        
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "marble") // set plane to a marble tile
        
        floorNode.geometry?.firstMaterial?.isDoubleSided = true // make the plane double sided
        
        floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0) // rotate so plane is horizontal
        
        floorNode.name = floorNodeName // naming floor node to distinguish it from others
        return floorNode
    }
    
    func addFurniture(hitTestResult:ARHitTestResult){
        
        let furnitureName = "Table" // furniture name
        
        guard let scene = SCNScene(named: "furnitures.scnassets/\(furnitureName).scn") else{return} // create scene from furniture
        
        let node = (scene.rootNode.childNode(withName: furnitureName, recursively: false))!  // create scene node for furniture
        let transform = hitTestResult.worldTransform  // transform for tap result
        let thirdColumn = transform.columns.3 // get the tap location in the world grid
        node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)  // set the position of the furniture
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    
}



extension ViewController:ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return} // check if anchor is a planee
        let planeNode = createFloorNode(anchor: planeAnchor) // create new floor node
        node.addChildNode(planeNode) // add the node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return} // check if anchor is a plane
        // remove old floor nodes
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        let planeNode = createFloorNode(anchor: planeAnchor) // create new floor node
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else {return} // check if anchor is a plane
        // remove all the nodes in order
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
}

