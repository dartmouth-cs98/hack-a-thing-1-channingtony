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
        
        sceneView.session.run(config)
        
        // create capsule
        let capsuleNode = SCNNode(geometry: SCNCapsule(capRadius: 0.03, height: 0.1))
        capsuleNode.position = SCNVector3(0.1, 0.1, -0.1) // position relative to world origin
        
        // add texture
        capsuleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue //1
        capsuleNode.eulerAngles = SCNVector3(0,0,Double.pi/2)//2
        
        sceneView.scene.rootNode.addChildNode(capsuleNode) // add capsule to view
    }
}
