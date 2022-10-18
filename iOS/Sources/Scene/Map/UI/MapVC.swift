import UIKit
import SnapKit
import Then
import MapKit
import RxCocoa
import CoreLocation

class MapVC: BaseVC<MapReactor> {
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
//        setMapView(coordinate: change(xAddress: "36.3751016880633", yAddress: "127.3820651968"), addr: "신세계")
//        self.mapView.showsUserLocation = true
//        self.mapView.setUserTrackingMode(.follow, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        if !token {
            let loginVC = BaseNC(rootViewController: LoginVC(reactor: LoginReactor()))
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
            token = true
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
        let region = MKCoordinateRegion(center: coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = addr
        mapView.addAnnotation(annotation)
        mapView.delegate = self
    }
}
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")

        annotationView.markerTintColor = UIColor.blue
        return annotationView
    }

}
