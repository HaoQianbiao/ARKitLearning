//
//  AREyeViewController.swift
//  ARKit test
//
//  Created by haoqianbiao on 2024/1/29.
//

import UIKit
import ARKit
import simd
class AREyeViewController: UIViewController, ARSCNViewDelegate {
    var arView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        arView = ARSCNView(frame: view.frame)
        arView.delegate = self
        view.addSubview(arView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
                    return
                }

        // 获取左眼和右眼的凝视点
        let leftEyeTransform = faceAnchor.leftEyeTransform
        let rightEyeTransform = faceAnchor.rightEyeTransform

        // 计算聚焦点
        let leftEyePosition = simd_make_float3(leftEyeTransform.columns.3.x, leftEyeTransform.columns.3.y, leftEyeTransform.columns.3.z)
        let rightEyePosition = simd_make_float3(rightEyeTransform.columns.3.x, rightEyeTransform.columns.3.y, rightEyeTransform.columns.3.z)
        let focusPoint = (leftEyePosition + rightEyePosition) / 2
        let screenPoint = arView.projectPoint(SCNVector3(focusPoint))
        print(screenPoint)
        // 更新你的界面或进行其他操作
//        DispatchQueue.main.async {
//            // 在这里更新你的界面，例如将一个3D对象放置在聚焦点上
//        }
    }
}
