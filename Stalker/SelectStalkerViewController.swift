//
//  SelectStalkerViewController.swift
//  Stalker
//
//  Created by Michael Simard on 5/6/19.
//  Copyright © 2019 Michael Simard. All rights reserved.
//

import UIKit

class SelectStalkerViewController: UIViewController {

    @IBOutlet weak var eyeView: EyeView!

    @IBAction func didTapSteveYzerman(_ sender: Any) {
        Utils.stalkerName = "Steve Yzerman"
        goToArticleList()
    }

    @IBAction func didTapTheNightKing(_ sender: Any) {
        Utils.stalkerName = "The Night King"
        goToArticleList()
    }

    @IBAction func didTapYourChoice(_ sender: Any) {

        let alertController = UIAlertController(title: "Choose who to stalk", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Stalker name"
        }
        let confirmAction = UIAlertAction(title: "Stalk", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            Utils.stalkerName = textField.text ?? ""
            self.goToArticleList()
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)

    }

    private func goToArticleList() {
        if Utils.stalkerName != "" {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = ArticleSplitViewController()
             }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.eyeView.animate()

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
