//
//  SecondViewController.swift
//  Bottom Sheet Example
//
//  Created by Artashes Noknok on 7/28/21.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    // Constants
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    let maxDimmedAlpha: CGFloat = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        setupPanGesture()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
    }
    
    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        containerView.addGestureRecognizer(panGesture)
    }

    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")

        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")

        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y

        // Handle based on gesture state
        switch gesture.state {
//        case .changed:
//            // This state will occur when user is dragging
//            if newHeight < maximumContainerHeight {
//                // Keep updating the height constraint
//                containerViewHeightConstraint?.constant = newHeight
//                // refresh layout
//                view.layoutIfNeeded()
//            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container

            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
//            else if newHeight < defaultHeight {
//                // Condition 2: If new height is below default, animate back to default
//                animateContainerHeight(defaultHeight)
//            }
//            else if newHeight < maximumContainerHeight && isDraggingDown {
//                // Condition 3: If new height is below max and going down, set to default height
//                animateContainerHeight(defaultHeight)
//            }
//            else if newHeight > defaultHeight && !isDraggingDown {
//                // Condition 4: If new height is below max and going up, set to max height at top
//                animateContainerHeight(maximumContainerHeight)
//            }
        default:
            break
        }
    }


    //MARK: Present and dismiss animation
   func animatePresentContainer() {
       // update bottom constraint in animation block
       UIView.animate(withDuration: 0.3) {
           self.containerViewBottomConstraint?.constant = 0
           // call this to trigger refresh constraint
           self.view.layoutIfNeeded()
       }
   }
   
   func animateShowDimmedView() {
       dimmedView.alpha = 0
       UIView.animate(withDuration: 0.4) {
           self.dimmedView.alpha = self.maxDimmedAlpha
       }
   }
   
   func animateDismissView() {
       // hide blur view
       dimmedView.alpha = maxDimmedAlpha
       UIView.animate(withDuration: 0.4) {
           self.dimmedView.alpha = 0
       } completion: { _ in
           // once done, dismiss without animation
           self.dismiss(animated: false)
       }
       // hide main view by updating bottom constraint in animation block
       UIView.animate(withDuration: 0.3) {
           self.containerViewBottomConstraint?.constant = self.defaultHeight
           // call this to trigger refresh constraint
           self.view.layoutIfNeeded()
       }
   }

}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
