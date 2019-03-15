//
//  ViewController.swift
//  HelloWorldSwift
//
//  Created by Eric Lange on 8/22/18.
//  Copyright © 2018 LiquidPlayer. All rights reserved.
//

import UIKit
import LiquidCore

class ViewController: UIViewController, LCMicroServiceDelegate, LCMicroServiceEventListener {

    var text: UILabel = UILabel()
    var button: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        text.textAlignment = .center
        text.text = "Hello World!"
        text.font = UIFont(name: "Menlo", size: 17)
        self.view.addSubview(text)
        
        button.setTitle("Sprechen Sie Deutsch!", for: .normal)
        button.titleLabel?.font = UIFont(name: "Menlo", size: 17)
        button.addTarget(self, action: #selector(onTouch), for: .touchUpInside)
        self.view.addSubview(button)
        
        self.text.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        let top = UILayoutGuide()
        let bottom = UILayoutGuide()
        self.view.addLayoutGuide(top)
        self.view.addLayoutGuide(bottom)
        
        let views = [ "text": text, "button": button, "top":top, "bottom":bottom ]
        let c1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[text]-|", metrics: nil, views: views)
        let c2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", metrics: nil, views: views)
        let c3 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[top]-[text]-[button]-[bottom(==top)]|",
                                                metrics: nil, views: views)
        self.view.addConstraints(c1 + c2 + c3)
    }
    
    @objc func onTouch(sender:UIButton!) {
        let url = LCMicroService.devServer()
        let service = LCMicroService(url: url, delegate: self)
        service?.start()
    }
    
    func onStart(_ service: LCMicroService) {
        service.addEventListener("ready", listener: self)
        service.addEventListener("pong", listener: self)
    }
    
    func onEvent(_ service: LCMicroService, event: String, payload: Any?) {
        if event == "ready" {
            service.emit("ping")
        } else if event == "pong" {
            DispatchQueue.main.async {
                var p = (payload as! Dictionary<String,AnyObject>)
                self.text.text = p["message"] as? String
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

