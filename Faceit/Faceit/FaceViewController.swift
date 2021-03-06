//
//  ViewController.swift
//  Faceit
//
//  Created by Witek on 07/04/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecogniser = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecogniser)
//            let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
//            tapRecogniser.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecogniser)
            let swipeUpRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecogniser.direction = .up
            faceView.addGestureRecognizer(swipeUpRecogniser)
            let swipeDownRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecogniser.direction = .down
            faceView.addGestureRecognizer(swipeDownRecogniser)
            updateUI() // Gets called only once, while the app launches
        }
    }
    
    public struct HeadShake {
        static let angle: CGFloat = .pi/6
        static let segmentDuration: TimeInterval = 0.5
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead() {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: { self.rotateFace(by: HeadShake.angle) }) { finished in
                if finished {
                    UIView.animate(
                        withDuration: HeadShake.segmentDuration,
                        animations: { self.rotateFace(by: -HeadShake.angle*2) }) { finished in
                            UIView.animate(
                                withDuration: HeadShake.segmentDuration,
                                animations: { self.rotateFace(by: HeadShake.angle)
                                }
                            )
                    
                    }
                }
        }
    }
    
    @IBAction func userDidTapped(_ sender: UITapGestureRecognizer) {
        shakeHead()
    }
    
    func increaseHappiness() {
        expression = expression.happier
    }
    
    func decreaseHappiness(){
        expression = expression.sadder
    }
    
    func toggleEyes(byReactingTo tapRecogniser: UITapGestureRecognizer) {
        if tapRecogniser.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown) {
        didSet {
            updateUI() // Gets called only then the properties are changed, not when it is initiated.
        }
    }
    
    func updateUI() {
        // ? after faceView is there to ignore the rest of the code if its nil, otherwise the app will crash
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
//            faceView?.eyesOpen = false
            break
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5, .frown: -1.0, .smile: 1.0, .neutral: 0.0, .smirk: -0.1]
    
}

