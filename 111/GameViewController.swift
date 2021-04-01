//
//  GameViewController.swift
//  111
//
//  Created by Admin on 30.03.2021.
//

import UIKit

class Positions {
    let first = Bool.random()
    let second = Bool.random()
    let third = Bool.random()
    let fourth = Bool.random()
    let fifth = Bool.random()
}

class GameViewController: UIViewController {
    @IBOutlet var GameView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ScoreLable: UILabel!
    var player: Player?
    var bullet: Bullet?
    var waves: [Wave] = []
    var score: Int = 0
    var firing: Bool = false
    weak var firingTimer: Timer?
    weak var spawnTimer: Timer?
    weak var waveTimer: Timer?
    weak var checkCollideTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerRect = CGRect(x: 0, y: 0, width: 50, height: 50)
        player = Player(frame: playerRect)
        if let player = player {
                player.center = CGPoint(x: mainView.frame.width/2, y: mainView.frame.height - player.frame.height)
        }
        
        mainView.addSubview(player!)
        firingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {_ in
            if let bullet = self.bullet {
                bullet.center.y -= self.mainView.frame.height/50
                if (bullet.center.y <= -50) {
                    bullet.removeFromSuperview()
                    self.bullet = nil
                    self.firing = false
                }
            }
        }
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true){_ in
            let wavesPos = Positions()
            let initWaveRect = CGRect(x: 0, y: -100, width: 50, height: 50)
            if (wavesPos.first) {
                let wave = Wave(frame: initWaveRect)
                wave.center.x = 10
                self.mainView.addSubview(wave)
                self.waves.append(wave)
            }
            if (wavesPos.second) {
                let wave = Wave(frame: initWaveRect)
                wave.center.x = self.mainView.frame.width / 4
                self.mainView.addSubview(wave)
                self.waves.append(wave)
            }
            if (wavesPos.third) {
                let wave = Wave(frame: initWaveRect)
                wave.center.x = self.mainView.frame.width / 2
                self.mainView.addSubview(wave)
                self.waves.append(wave)
            }
            if (wavesPos.fourth) {
                let wave = Wave(frame: initWaveRect)
                wave.center.x = self.mainView.frame.width / 4 * 3
                self.mainView.addSubview(wave)
                self.waves.append(wave)
            }
            if (wavesPos.fifth) {
                let wave = Wave(frame: initWaveRect)
                wave.center.x = self.mainView.frame.width - 10
                self.mainView.addSubview(wave)
                self.waves.append(wave)
            }
        }
        waveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {_ in
            for wave in self.waves {
                if (wave.center.y >= self.mainView.frame.height - 25) {
                    self.GameOver()
                }
                wave.center.y += self.mainView.frame.height/300
            }
        }
        checkCollideTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){_ in
            var pos = 0;
            for wave in self.waves {
                if let bullet = self.bullet {
                    if(wave.frame.intersects(bullet.frame)) {
                        self.score += 10
                        self.ScoreLable.text = "Score: \(self.score)"
                        self.firing = false
                        self.waves.remove(at: pos)
                        wave.removeFromSuperview()
                        bullet.removeFromSuperview()
                        self.bullet = nil
                    }
                }
                if let player = self.player {
                    if (wave.frame.intersects(player.frame)) {
                        self.GameOver()
                    }
                }
                pos += 1
                }
            }
        }

    @IBAction func TapButtonRight(_ sender: Any) {
        if let player = player {
            if (player.center.x >= mainView.frame.width - player.frame.width/2) {
                return
            }
            else {
                UIView.animate(withDuration: 0.15, animations: { self.player?.center.x += player.frame.width/2})
            }
        }
    }
    
    @IBAction func TapButtonLeft(_ sender: Any) {
        if let player = player {
                    if (player.center.x <= 0 + player.frame.width/2) {
                        return
                    }
                    else {
                        UIView.animate(withDuration: 0.15, animations: { self.player?.center.x -= player.frame.width/2})
                    }
                }
    }
    
    @IBAction func TapButtonFire(_ sender: Any) {
        if (firing) {
            return
        }
        else {
            if let player = player {
                firing = true
                let bulletRect = CGRect(x: 0, y: 0, width: 25, height: 25)
                bullet = Bullet(frame: bulletRect)
                bullet?.center = CGPoint(x: player.center.x, y: player.center.y - 35)
                mainView.addSubview(bullet!)
            }
        }
    }
    
    func GameOver() {
        let alert = UIAlertController(title: "GAME OVER", message: "Final score: \(score)", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Go Back", style: .cancel, handler: {_ in
                                            self.dismiss(animated: true, completion: nil)})
        alert.addAction(actionCancel);
        self.present(alert, animated: true, completion: nil)
        firingTimer?.invalidate()
        spawnTimer?.invalidate()
        waveTimer?.invalidate()
        checkCollideTimer?.invalidate()
    }
}
