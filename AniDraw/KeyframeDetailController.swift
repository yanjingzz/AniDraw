//
//  KeyframeDetailController.swift
//  AniDraw
//
//  Created by Mike on 7/12/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class KeyframeDetailController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var positionCurveLabel: UILabel!
    @IBOutlet weak var angleCurveLabel: UILabel!
    
    @IBOutlet weak var positionPickerView: UIPickerView!
    @IBOutlet weak var anglePickerView: UIPickerView!
    
    @IBOutlet weak var slider: UISlider!
    var keyframeIndex: Int!
    var delegate: KeyframeDetailControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = 0.5
        anglePickerView.selectRow(3, inComponent: 0, animated: false)
        positionPickerView.selectRow(3, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(animated: Bool) {
        let pRow = positionPickerView.selectedRowInComponent(0)
        let aRow = anglePickerView.selectedRowInComponent(0)
        let data = KeyframeDetailData(index: keyframeIndex,time: Double(slider.value), positionCurve: Keyframe.Curve(rawValue: pRow)!, angleCurve: Keyframe.Curve(rawValue: aRow)!)
        delegate?.keyframeDetailControllerWillDisapper(withData: data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        timeLabel.text = "\(sender.value)s"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Keyframe.Curve.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Keyframe.Curve(rawValue: row)?.description
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == positionPickerView {
            positionCurveLabel.text = Keyframe.Curve(rawValue: row)?.description
        } else if pickerView == anglePickerView {
            angleCurveLabel.text = Keyframe.Curve(rawValue: row)?.description
        }
    }
    func setData(data: KeyframeDetailData) {
        keyframeIndex = data.index
        var time = Float(data.time)
        time = time < 0 ? 0 : time
        time = time > 2.5 ? 2.5 : time
        slider.value = time
        timeLabel.text = "\(time)s"
        anglePickerView.selectRow(data.angleCurve.rawValue, inComponent: 0, animated: false)
        positionPickerView.selectRow(data.positionCurve.rawValue, inComponent: 0, animated: false)
    }
    
}
struct KeyframeDetailData {
    let index: Int
    let time: NSTimeInterval
    let positionCurve: Keyframe.Curve
    let angleCurve: Keyframe.Curve
}

protocol KeyframeDetailControllerDelegate {
    func keyframeDetailControllerWillDisapper(withData data: KeyframeDetailData)
}