//
//  ARJudgeViewController.swift
//  ARKit test
//
//  Created by haoqianbiao on 2024/1/29.
//

import UIKit

import ARKit

class ARJudgeViewController: UIViewController, ARSCNViewDelegate {
    var arView: ARSCNView!
    var time: NSInteger!
    var total: Float!
    override func viewDidLoad() {
        super.viewDidLoad()

        arView = ARSCNView(frame: view.frame)
        arView.delegate = self
        view.addSubview(arView)
        time = 0
        total = 0
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

        // 获取左眼和右眼的位置
        let leftEyePosition = faceAnchor.leftEyeTransform.columns.3
        let rightEyePosition = faceAnchor.rightEyeTransform.columns.3

        // 计算左眼和右眼的方向向量
        let leftEyeDirection = SCNVector3(leftEyePosition.x, leftEyePosition.y, -leftEyePosition.z)
        let rightEyeDirection = SCNVector3(rightEyePosition.x, rightEyePosition.y, -rightEyePosition.z)

        // 计算左眼和右眼的方向向量的点积
        let dotProduct = dot(leftEyeDirection, rightEyeDirection)
        total += dotProduct
        time += 1
        if (time == 180) {
            // 判断眼睛是否斜视
            let isStrabismus = Float(total / 180) < 0.9
            // 更新你的界面或进行其他操作
            let message:String?
            if (isStrabismus) {
                message = String("您的眼睛可能存在斜视情况，请尽快就医！")
            } else {
                message = String("您的眼睛非常健康！！！")
            }
            
            let alertController =  UIAlertController(title: "检测结果",
                                                         message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                    action in
                    self.navigationController?.topViewController?.dismiss(animated: true)
                })
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    // 在这里更新你的界面，根据 isStrabismus 的值来显示相应的信息
                    self.present(alertController, animated: true)
                }
            time = 0
            arView.session.pause()
        }
    }

    func dot(_ a: SCNVector3, _ b: SCNVector3) -> Float {
        return a.x * b.x + a.y * b.y + a.z * b.z
    }
}
