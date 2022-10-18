import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import CoreLocation

class MapVC: BaseVC<MapReactor> {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation! // 내 위치 저장
    private let mapView = MKMapView()
    var token = false
    override func setLayout() {
        mapView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    override func configureVC() {
        setMapView(coordinate: change(xAddress: "36.390906587662", yAddress: "127.36218898382"), addr: "대덕소프트웨어 마이스터고")
        setMapView(coordinate: change(xAddress: "36.3751016880633", yAddress: "127.3820651968"), addr: "신세계")
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    override func viewDidAppear(_ animated: Bool) {
        if !token {
            let loginVC = BaseNC(rootViewController: LoginVC(reactor: LoginReactor()))
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
            token = true
        }
        let selectSchoolVC = DetailMapVC()
        if #available(iOS 15.0, *) {
            if let sheet = selectSchoolVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.preferredCornerRadius = 32
                self.present(selectSchoolVC, animated: true)
            }
        }
    }
    override func addView() {
        [mapView].forEach {
            view.addSubview($0)
        }
    }
    func change(xAddress: String, yAddress: String) -> CLLocationCoordinate2D {
        let mapXY = CLLocationCoordinate2D(latitude: Double(xAddress) ?? 0, longitude: Double(yAddress) ?? 0)
        return mapXY
    }
    func setMapView(coordinate: CLLocationCoordinate2D, addr: String) {
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
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
}
