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
    private var color = PublishRelay<String>()
    private var contentsVC: DetailMapVC!
    private let viewAppear = PublishRelay<Void>()
    private let viewModel = MapViewModel()
    private var annotations = [MKAnnotation]()

    override func viewWillAppear(_ animated: Bool) {
        viewAppear.accept(())
    }
    override func configureVC() {
        setUserLocation()
        floatingPanelView()
        mapView.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.reloadData (_:)),
            name: NSNotification.Name("reloadData"),
            object: nil
        )
    }
    @objc func reloadData(_ notification: Notification) {
        removeAllAnnotations()
        viewAppear.accept(())
    }
    override func bind() {
        mapView.delegate = self
        let input = MapViewModel.Input(viewAppear: viewAppear.asSignal())
        let output = viewModel.transform(input)
        output.locationList.subscribe(onNext: { [self] in
            $0.forEach {
                setMapView(
                    coordinate: change(
                        xAddress: $0.latitude,
                        yAddress: $0.longitude
                    ),
                    addr: $0.buildingName,
                    color: $0.color) }
        }).disposed(by: disposeBag)
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
        let mapXY = CLLocationCoordinate2D(latitude: Double(yAddress) ?? 0.0, longitude: Double(xAddress) ?? 0.0)
        return mapXY
    }
    private func setMapView(coordinate: CLLocationCoordinate2D, addr: String, color: String) {
        let annotation = CustomPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = addr
        annotation.color = color
        mapView.addAnnotation(annotation)
    }
    private func removeAllAnnotations() {
        let annotations = mapView.annotations
        if annotations.count != 0 {
          for annotation in annotations {
            mapView.removeAnnotation(annotation)
          }
        } else {
          return
        }
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
            let customAnnotation = annotation as? CustomPointAnnotation
            let annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = customAnnotation?.color.colorDistinction()
            annotationView.glyphImage = UIImage(systemName: "mappin.and.ellipse")
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
