//
//  ViewController.swift
//  ChanningTony
//
//  Created by Alex Chan on 1/8/19.
//  Copyright © 2019 cs98. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // For plane detection
        config.planeDetection = .horizontal

        sceneView.session.run(config)
        sceneView.delegate = self

    }
    
    func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))) // create a plane rooted to the anchor
        
        floorNode.position=SCNVector3(anchor.center.x,0,anchor.center.z) // set plane position
        
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue // set plane color
        
        floorNode.geometry?.firstMaterial?.isDoubleSided = true // make the plane double sided
        
        floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0) // rotate so plane is horizontal
        return floorNode
    }
    
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



extension ViewController:ARSCNViewDelegate{}

