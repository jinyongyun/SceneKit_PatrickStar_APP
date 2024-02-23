# SceneKit_PatrickStar_APP
뚱이 2D 이미지를 인식해서 3D 모델로 나타내는 앱!


오늘 해볼 것은 2D 이미지를 인식하여 3D 모델로 가상공간에 띄워보는 앱을 만들어 볼 것이다.

아이들이 갖고 노는 포켓몬스터 카드나 유희왕(?)카드에 실제로 모델을 띄우는 방식으로 게임을 만들면 더 효과가 좋았을 거라는 생각이 들었다.

이런 기술의 가장 기초인 2D 이미지를 3D로 바꾸는 방법!

이것이 오늘 핵심 기술이다.

필자는 오늘 뚱이 이미지를 인식하여 그 이미지 위에 실제 뚱이 모델을 띄워보려고 한다.

뚱이 .dae 모델을 다운로드 한다.

[전문가용 3D 모델 :: TurboSquid](https://www.turbosquid.com/ko/)

위의 사이트에서 .dae 모델 (xcode에서 사용되는 scn으로 변환할 수 있다)을 다운받았다.

당연히 인식할 수 있는 이미지도 준비해야 한다. 

뚱이.png를 준비하고 배경색으로 검은색을 줬다. 

왠지 인식이 더 잘 될 것 같았다.

일단 다운받은 Patrick.dae를 art.scnassets에 넣어준다. 

(뚱이의 영문명이 Patrick이다. 뚱이는 고학력인데 취업을 못한 청년을 위한 캐릭터라 할 줄 아는 건 많다 ㅎㅎ)

Editor를 클릭해 **Convert to SceneKit file format**  을 눌러 .dae를 scn 타입으로 변환한다.
<img width="1642" alt="스크린샷 2024-02-21 오후 4 44 43" src="https://github.com/jinyongyun/SceneKit_PatrickStar_APP/assets/102133961/f499cb84-5d56-49fc-b072-319a190d151c">


이제 우리가 카메라로 찍었을 때 인식될 이미지를 설정해줘야 한다.

아까 위에서 말한 뚱이.png 이미지를 약간 수정해줘야 한다. 

노출, 대비, 선명도를 높여줘야 인식률이 올라간다 (이것 때문에 얼마나 고생했는지ㅠㅠㅠㅠ)
<img width="1106" alt="스크린샷 2024-02-21 오후 4 48 45" src="https://github.com/jinyongyun/SceneKit_PatrickStar_APP/assets/102133961/e2fec555-e956-4013-b8a5-94a675c483ee">


수정한 이미지를 new AR Resource Group으로 생겨난 새로운 폴더에 추가한다.
<img width="1386" alt="스크린샷 2024-02-21 오후 4 50 33" src="https://github.com/jinyongyun/SceneKit_PatrickStar_APP/assets/102133961/536a1a28-d5c0-46a8-990f-86bc2bedef84">


필자는 뚱이의 영문명인 Patrick으로 폴더 이름을 설정했다.

**이때 노란색 느낌표가 뜨면서 에러가 발생할 텐데…**

 사진의 크기를 설정하지 않아서 발생한 것이다.
<img width="1403" alt="스크린샷 2024-02-21 오후 4 59 46" src="https://github.com/jinyongyun/SceneKit_PatrickStar_APP/assets/102133961/6a238281-da3a-4542-af69-28de1e64bb19">

<img width="1403" alt="스크린샷 2024-02-21 오후 4 59 46" src="https://github.com/jinyongyun/SceneKit_PatrickStar_APP/assets/102133961/df8cf89a-4616-4a9a-9c07-c15424f53cf3">

***오른쪽에 보이는 Size 설정에서 Width와 Height의 단위는 m(미터)이므로 반드시 주의하자!!***

Units(단위)를 바꿔서 cemtimeter로 설정할 수도 있다.


 height만 설정해줘도 width은 알아서 설정해준다.

이제 기본 viewController로 이동해서 코드 작업을 해주자!

이번에 사용할 Configuration은 2D 이미지를 인식하는 역할인 ***ARImageTrackingConfiguration***이다.

(이전에는 계속 ARWorldTrackingConfiguration()을 사용했다)

우리가 Asset > Patrick에 넣었던 이미지를 ARReferenceImage 클래스를 이용해서 가져와야 한다.

<aside>
💡 참고로 우리가 이전부터 사용했던 ARWorldTrackingConfiguration() 또한 이미지 추적이 가능하긴 하다. 하지만 이녀석은 여러 이미지를 인식할 때 더 많이 쓰이고, 우리가 이번에 사용하는 ARImageTrackingConfiguration은 한 두개의 이미지를 중점으로 인식하여 인식률이 높은 Configuration이다.

</aside>

```swift
// 여러 이미지들을 인식
let configuration = ARWorldTrackingConfiguration()
configuration.detectionImages = referenceImages

// 하나 두개 정도만 중점으로 인식
let configuration = ARImageTrackingConfiguration()
configuration.trackingImages = referenceImages
```

공식문서에서는 다음과 같이 설명하고 있다.

> but solely by detecting and tracking the motion of known 2D images in view of the camera. `[ARWorldTrackingConfiguration](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration)` can also detect images, but each configuration has its own strengths:
> 

> World tracking has a higher performance cost than image-only tracking, so your session can reliably track more images at once with `ARImageTrackingConfiguration`. (**월드 추적은 이미지만 추적하는 것보다 성능 비용이 더 높으므로 세션은 를 사용하여 한 번에 더 많은 이미지를 안정적으로 추적할 수 있습니다**)
> 

> Image-only tracking lets you anchor virtual content to known images only when those images are in view of the camera. World tracking with image detection lets you use known images to add virtual content to the 3D world, and continues to track the position of that content in world space even after the image is no longer in view.(**이미지 전용 추적을 사용하면 해당 이미지가 카메라에 보이는 경우에만 알려진 이미지에 가상 콘텐츠를 고정할 수 있습니다. 이미지 감지를 통한 월드 추적을 사용하면 알려진 이미지를 사용하여 3D 세계에 가상 콘텐츠를 추가할 수 있으며, 이미지가 더 이상 보이지 않는 후에도 월드 공간에서 해당 콘텐츠의 위치를 계속 추적할 수 있습니다**.)
> 

> World tracking works best in a stable, nonmoving environment. You can use image-only tracking to add virtual content to known images in more situations—for example, an advertisement inside a moving subway car. (**월드 추적은 안정적이고 움직이지 않는 환경에서 가장 잘 작동합니다. 이미지 전용 추적을 사용하면 더 많은 상황(예: 움직이는 지하철 차량 내부의 광고)에서 알려진 이미지에 가상 콘텐츠를 추가할 수 있습니다.**)
> 

이미지를 인스턴스화 시켰으니, 이젠 인식 과정을 그려보자.

**카메라로 이미지를 인식하면 그 이미지 바로 위에 저번에 했던 것처럼 평면 노드를 만들어 올리고, 그 평면을 지면으로 3D 모델을 올릴 것이다.**

그럼 이 이미지 인식은 누가 담당하는 것일까?

바로 ARSCNViewDelegate내에 정의되어있는 renderer 함수가 그 주인공이다.

공식문서에는 다음과 같이 적혀있다.

> Asks the delegate to provide a SceneKit node corresponding to a newly added anchor.
> 

새롭게 추가된 anchor와 일치하는 scn 노드를 제공하도록 델리게이트에게 요청한다!

즉 이미지를 인식한 그곳에서 앵커 객체를 받아와서 해당 위치에 노드를 만들어주는 메서드이다.

(앵커는 예전에 배웠다! 기억나는가? 물리적 환경에서 항목의 위치와 방향을 지정하는 개체)

```swift
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
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.4)
        
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
    
}

```

마지막 부분에서 [imageAnchor.referenceImage.name](http://imageAnchor.referenceImage.name) 속성으로 if let binding을 이용해 옵셔널을 무사히 벗겨내면 makeModel하도록 해줬다.

makeModel 메서드가 뭐냐고?

당연히 아직 모를 것이다. 아직 안 만들어줬으니까!

makeModel 메서드는 위에서 만들어 준 planeNode 위에 이미지를 바탕으로한 3D model을 정확히는 노드를 올려주는 메서드이다.

이때 우리는 이미지를 뚱이 이미지 하나만 사용하지만, 다른 이미지를 넣을 가능성과 확장성을 고려해

따로 Enum 파일을 만들어 줄 것이다.

```swift
//  Picture.swift
//  PatrickStarAR
//
//  Created by jinyong yun on 2/21/24.
//

import Foundation

enum Picture {
    case Patrick
    
    // 파일 이름
    var name: String {
        switch self {
        case .Patrick: return "Patrick"
        }
    }
    
    // 파일이 있는 위치
    var assetLocation: String {
        switch self {
        case .Patrick:
            return "art.scnassets/Patrick.scn"
        }
    }
}

```

간단한 enum 형식이다. 

파일 이름과 url을 갖고 있다.

makeModel은 다음과 같다.

```swift
    func makeModel(on planeNode: SCNNode, name: String) {
           switch name { //뚱이 하나밖에 없지만 미래에 확장성을 고려해서 switch문
               
           case Picture.Patrick.name: //뚱이
               //scn 파일 가져와서
               guard let PatrickScene = SCNScene(named: Picture.Patrick.assetLocation) else { return }
               
               // 노드 뽑아내기
               guard let PatrickNode = PatrickScene.rootNode.childNodes.first else { return }
               
               // 생성된 3D 모델의 각도를 조정
               PatrickNode.eulerAngles.x = Float.pi/2
               PatrickNode.eulerAngles.z = -(Float.pi/2)
               
               planeNode.addChildNode(PatrickNode)
               
           default: break
           }
       }
```

### 발생한 문제

아니 분명 이미지 인식은 되는데 (테스트를 위해 alpha값을 1을 줘서 이미지를 인식하면 하얀색으로 만들어줬다)

```swift
// plane을 투명하게 만든다 (diffuse 사용)
plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 1.0)
```

이미지가 나타나지 않아서…

코드를 한참을 살펴보니

```swift
// 노드 뽑아내기
 guard let PatrickNode = PatrickScene.rootNode.childNodes.first else { return }
```

이부분!

그래 이부분이 거슬렸다.

내가 구한 .dae 그리고 변환한 scn 파일을 살펴보면 여러 childNodes로 구성되어있는데

여기서 그냥 첫번째 childNode만 뽑아내니까 안보이는 것이 아닐까?

하는 생각이 들어 이 부분을

```swift
func makeModel(on planeNode: SCNNode, name: String) {
           switch name { //뚱이 하나밖에 없지만 미래에 확장성을 고려해서 switch문
               
           case Picture.Patrick.name: //뚱이
               //scn 파일 가져와서
               guard let PatrickScene = SCNScene(named: Picture.Patrick.assetLocation) else { return }
               
//               // 노드 뽑아내기
//               guard let PatrickNode = PatrickScene.rootNode.childNodes.first else { return }
               
//               // 생성된 3D 모델의 각도를 조정
//               PatrickNode.eulerAngles.x = Float.pi/2
//               PatrickNode.eulerAngles.z = -(Float.pi/2)
               
               let PatrickNode = PatrickScene.rootNode
               
               planeNode.addChildNode(PatrickNode)
               
           default: break
           }
       }
```

그냥 단순하게 루트 노드를 가져오도록 바꾸니

보이긴 보이는데…



https://github.com/jinyongyun/SceneKit_PatrickStar_APP/assets/102133961/5b33a8ef-4bb4-4a66-905f-4be24f91b67e


뚱이가 너무 커서

한 화면에 다 안담긴다.

결국 노드 사이즈를 조정해줬다.

```swift
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
```

## 실제 구동 화면



https://github.com/jinyongyun/SceneKit_PatrickStar_APP/assets/102133961/63c38423-05b7-4598-8e5b-4fed12679da5

