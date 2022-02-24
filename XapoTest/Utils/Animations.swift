//
//  Animations.swift
//  XapoTest
//
//  Created by Olivier on 2/12/22.
//

import Foundation
import UIKit



func showAndAnimateItems(title:UILabel, subtitle:UILabel, bodyText:UILabel,logo:UIImageView,button:UIButton,xapoBtn:UIButton) {
    UIView.animate(withDuration: 1.5) {
        title.alpha = 1.0
    } completion: {_ in
        UIView.animate(withDuration: 1.0) {
            subtitle.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 1.0) {
                bodyText.alpha = 1.0
                logo.alpha = 1.0
                logo.bounceImg()
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.4) {
                    button.alpha = 1.0
                    xapoBtn.alpha = 1.0
                }
            }
        }
    }
}


    
func bounceAndModal(btn:UIButton,vc:UIViewController){
        UIView.animate(withDuration: 0.2,
            animations: {
                btn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2,
                    animations: {
                        btn.transform = CGAffineTransform.identity
                    },
                    completion: { _ in
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let controller = storyboard.instantiateViewController(withIdentifier: "reposVC") as? ReposViewController else{
                            fatalError("Could not find vc")
                        }
                        controller.modalPresentationStyle = .fullScreen
                        controller.modalTransitionStyle = .crossDissolve
                        vc.present(controller, animated: true, completion: nil)
                    })
            })
    }




extension UIImageView  {
    
    func bounceImg(){
        UIView.animate(withDuration: 0.1,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform.identity
                }
            })
    }
}


extension UITextField  {
    
    func bounceTF(){
        UIView.animate(withDuration: 0.2,
            animations: {
                self.transform = CGAffineTransform(scaleX: 20, y: 0.8)
            })
    }
}
