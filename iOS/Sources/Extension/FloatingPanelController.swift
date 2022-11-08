import UIKit
import FloatingPanel

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 20
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        surfaceView.grabberHandle.isHidden = false
        surfaceView.appearance = appearance
    }
}
