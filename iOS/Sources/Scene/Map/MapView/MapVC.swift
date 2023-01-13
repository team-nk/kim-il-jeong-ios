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
    private let viewAppear = PublishRelay<Void>()
    private let viewModel = MapViewModel()
    override func configureVC() {
        setUserLocation()
        floatingPanelView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData (_:)),
            name: NSNotification.Name("reloadData"),
            object: nil
        )
    }
    @objc func reloadData(_ notification: Notification) {
        viewAppear.accept(())
    }
    override func bind() {
        let input = MapViewModel.Input(viewAppear: viewAppear.asSignal())
        let output = viewModel.transform(input)
        output.locationList.subscribe(onNext: { [self] in
            for count in $0 {
                setMapView(coordinate: change(xAddress: count.latitude, yAddress: count.longitude), addr: count.address)
            }
        }).disposed(by: disposeBag)
    }
    override func viewWillAppear(_ animated: Bool) {
        viewAppear.accept(())
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
    private func change(xAddress: Double, yAddress: Double) -> CLLocationCoordinate2D {
        let mapXY = CLLocationCoordinate2D(latitude: xAddress, longitude: yAddress)
        return mapXY
    }
    private func setMapView(coordinate: CLLocationCoordinate2D, addr: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = addr
        mapView.addAnnotation(annotation)
        mapView.delegate = self
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
        let center = CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 0,
                                            longitude: location?.coordinate.longitude ?? 0)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
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
