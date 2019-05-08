//
//  SettingsViewController.swift
//  Stalker
//
//  Created by Michael Simard on 5/6/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func didSelectSwitchStalker(settingsViewController: SettingsViewController)
}
class SettingsViewController: UIViewController {

    weak var delegate: SettingsViewControllerDelegate?

    @IBAction func switchStalkerPressed(_ sender: Any) {
        Utils.stalkerName = ""
        delegate?.didSelectSwitchStalker(settingsViewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
