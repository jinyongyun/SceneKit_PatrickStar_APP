//
//  ViewController.swift
//  PatrickStarAR
//
//  Created by jinyong yun on 2/21/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting =  true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ARImageTrackingConfiguration으로 2D 이미지를 인식.
        let configuration = ARImageTrackingConfiguration()
        
        // Asset에서 이미지를 인식할 이미지 폴더를 선택(필자는 Pictures)
        // main에서 실행되므로 Bundle.main
        guard let imageTracked = ARReferenceImage.referenceImages(inGroupNamed: "Pictures", bundle: Bundle.main) else { return }
        
        // ARKit에서 어떤 이미지를 추적할 것인가
        configuration.trackingImages = imageTracked
        
        // 몇 개의 이미지를 추적할 것인가
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
}


extension ViewController: ARSCNViewDelegate {
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // 빈 노드 생성
        let node = SCNNode()
        
        // 감지된 anchor를 ARImageAnchor로 다운캐스팅
        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        
        // 감지된 이미지의 크기를 입력해 준다(그래야 그 크기만큼 plane 만들지)
        // 카드위에 3D객체를 렌더링
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        
        // plane을 투명하게 만든다 (diffuse 사용)
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.3)
        
        // 위에 생성한 plane의 골격을 설정한다
        let planeNode = SCNNode(geometry: plane)
        
        // plane은 처음 생성시 수직평면으로 생성이 되므로 우리는 스티커와 동일하게 90도로 눞여 준다
        // -90도 해주면 ok
        planeNode.eulerAngles.x = -(Float.pi / 2)
        
        node.addChildNode(planeNode)
        
        // 감지된 imageAnchor의 이름 속성에 접근해 모델을 만든다.
        if let imageName = imageAnchor.referenceImage.name {
            makeModel(on: planeNode, name: imageName)
        }
        
        return node
    }
    
    func makeModel(on planeNode: SCNNode, name: String) {
           switch name { //뚱이 하나밖에 없지만 미래에 확장성을 고려해서 switch문
               
           case Picture.Patrick.name: //뚱이
               //scn 파일 가져와서
               guard let PatrickScene = SCNScene(named: Picture.Patrick.assetLocation) else { return }
               

               // 여기서 루트 노드만 뽑아내야 뚱이 보임
               let PatrickNode = PatrickScene.rootNode
               
               // 노드 사이즈 조정
               PatrickNode.scale = SCNVector3(0.1, 0.1, 0.1)
               
               
               planeNode.addChildNode(PatrickNode)
               
           default: break
           }
       }
    
}
