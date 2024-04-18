import AVFoundation
import UIKit

class ViewController: UIViewController {
  @IBOutlet var label: UILabel!
  @IBOutlet var progressBar: UIProgressView!

  var player: AVAudioPlayer?

  let eggSeconds = [
    "Soft": 5,
    "Medium": 7 * 60,
    "Hard": 12 * 60,
  ]
  var timer = Timer()
  var time = 0
  var selectedEggType: String?

  @IBAction func hardnessSelected(_ sender: UIButton) {
    let hardness = sender.currentTitle!

    selectedEggType = hardness
    label.text = "Boiling..."

    time = 0
    progressBar.progress = 0
    timer.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTime)
  }

  func updateTime(_ timer: Timer) {
    time += 1
    guard let eggTime = eggSeconds[selectedEggType!] else { return }

    let progress = Float(time) / Float(eggTime)
    progressBar.progress = progress

    if progress >= 1 {
      timer.invalidate()
      label.text = "Done!"
      playSound()
    }
  }

  func playSound() {
    guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

      guard let player = player else { return }

      player.play()
    } catch let error as NSError {
      print(error.description)
    }
  }
}
