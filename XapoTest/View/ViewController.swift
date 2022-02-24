//
//  ViewController.swift
//  XapoTest
//
//  Created by Olivier on 2/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var xapoBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideItems()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // screen elements animations
        showAndAnimateItems(title: titleLabel, subtitle: subtitleLabel, bodyText: bodyTextLabel, logo: logoImg, button: enterBtn, xapoBtn: xapoBtn)
    }
    
    
    @IBAction func enterAction(_ sender: UIButton) {
        bounceAndModal(btn:sender,vc:self)
    }
    
    func hideItems() {
        self.titleLabel.alpha = 0.0
        self.subtitleLabel.alpha = 0.0
        self.bodyTextLabel.alpha = 0.0
        self.enterBtn.alpha = 0.0
        self.logoImg.alpha = 0.0
        self.xapoBtn.alpha  = 0.0
    }
    
    @IBAction func goToXapo(_ sender: Any) {
        
        if let url = URL(string: "https://www.xapo.com/") {
            UIApplication.shared.open(url)
        }
    }
    
   
    
    @IBAction func openWebVIew(_ sender: UIButton) {
        
        var url = ""
        if sender.tag == 1 {
            url = "https://legal.xapo.com/xapo-privacy-policy/"
        } else if sender.tag == 2 {
            url = "https://legal.xapo.com/website-terms-use/"
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "policyVC") as! PrivacyPolicyViewController
        vc.url = url
       // vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

