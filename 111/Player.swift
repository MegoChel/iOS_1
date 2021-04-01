//
//  Player.swift
//  111
//
//  Created by Admin on 30.03.2021.
//

import UIKit

class Player: UIImageView {

    func setup() {
        let image: UIImage? = UIImage(named: "ForsenCD")
        self.contentMode = .redraw
        self.image = image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}
