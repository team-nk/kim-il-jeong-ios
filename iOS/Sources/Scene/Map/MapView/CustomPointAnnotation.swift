import MapKit
import UIKit

class CustomPointAnnotation: MKPointAnnotation {
    var color = ""
    init(color: String = "") {
        self.color = color
    }
}
