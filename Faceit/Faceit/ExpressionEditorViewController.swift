//
//  ExpressionEditorViewController.swift
//  Faceit
//
//  Created by Witek on 20/09/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import UIKit

class ExpressionEditorViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eyeControl: UISegmentedControl!
    @IBOutlet weak var mouthControl: UISegmentedControl!
    
    fileprivate let eyeChoises: [FacialExpression.Eyes] = [.open, .closed, .squinting]
    fileprivate let mouthChoises: [FacialExpression.Mouth] = [.frown, .smirk, .neutral, .grin, .smile]
    
    private var faceViewController: BlinkingFaceViewController?
    var name: String {
        return nameTextField?.text ?? ""
    }
    
    var expression: FacialExpression {
        return FacialExpression(
            eyes: eyeChoises[eyeControl?.selectedSegmentIndex ?? 0],
            mouth: mouthChoises[mouthControl?.selectedSegmentIndex ?? 0])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed Face" {
            faceViewController = segue.destination as? BlinkingFaceViewController
            faceViewController?.expression = expression
        }
    }
    
    @IBAction func updateFace(_ sender: UISegmentedControl) {
        faceViewController?.expression = expression
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if popoverPresentationController == navigationController?.popoverPresentationController {
            if popoverPresentationController?.arrowDirection != .unknown {
                navigationItem.leftBarButtonItem = nil
            }
        }
        var size = tableView.minimumSize(forSection: 0)
        size.height -= tableView.heightForRow(at: IndexPath(item: 1, section: 0))
        size.height -= size.width
        preferredContentSize = size
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.size.width
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
}

extension ExpressionEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension UITableView {
    
    func minimumSize(forSection section: Int) -> CGSize {
        var width: CGFloat = 0
        var height : CGFloat = 0
        for row in 0..<numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = cellForRow(at: indexPath) ?? dataSource?.tableView(self, cellForRowAt: indexPath) {
                let cellSize = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                width = max(width, cellSize.width)
                height += heightForRow(at: indexPath)
            } }
        return CGSize(width: width, height: height)
    }
    
    func heightForRow(at indexPath: IndexPath? = nil) -> CGFloat {
        if indexPath != nil, let height = delegate?.tableView?(self, heightForRowAt: indexPath!) {
            return height
        } else {
            return rowHeight
        }
    }
    
}