import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import CoreLocation
import FloatingPanel

class MapVC: BaseVC {
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    private let mapView = MKMapView()
    private var fpc: FloatingPanelController!
    private var contentsVC: DetailMapVC!
    override func configureVC() {
        setMapView(coordinate: change(xAddress: "36.390906587662", yAddress: "127.36218898382"), addr: "대덕소프트웨어 마이스터고")
        setMapView(coordinate: change(xAddress: "36.3751016880633", yAddress: "127.3820651968"), addr: "신세계")
        setUserLocation()
        floatingPanelView()
    }
    override func addView() {
        self.view.addSubview(mapView)
    }
    override func setLayout() {
        mapView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    private func setUserLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    private func floatingPanelView() {
        contentsVC = DetailMapVC()
        fpc = FloatingPanelController()
        fpc.changePanelStyle()
        fpc.set(contentViewController: contentsVC)
        fpc.track(scrollView: contentsVC.detailLocationTabelView)
        fpc.addPanel(toParent: self)
        fpc.layout = MapFloatingPanelLayout()
        fpc.invalidateLayout()
    }
    private func change(xAddress: String, yAddress: String) -> CLLocationCoordinate2D {
        let mapXY = CLLocationCoordinate2D(latitude: Double(xAddress) ?? 0, longitude: Double(yAddress) ?? 0)
        return mapXY
    }
    private func setMapView(coordinate: CLLocationCoordinate2D, addr: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = addr
        mapView.addAnnotation(annotation)
        mapView.delegate = self
    }
}

extension MapVC: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation.title {
        case "My Location":
            let annotationView = MKUserLocationView(annotation: annotation, reuseIdentifier: "MyMarker")
            return annotationView
        default:
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = .blue
            return annotationView
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude,
                                            longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
}

class MapFloatingPanelLayout: FloatingPanelLayout {

    var position: FloatingPanelPosition = .bottom

    var initialState: FloatingPanelState = .tip

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 60, edge: .bottom, referenceGuide: .safeArea),
            .full: FloatingPanelLayoutAnchor(absoluteInset: 160, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 292, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
