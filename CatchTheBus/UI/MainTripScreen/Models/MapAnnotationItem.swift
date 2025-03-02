enum MapAnnotationItem: Identifiable {
    case bus(BusAnnotation)
    case stop(AppRouteModel)
    
    var id: String {
        switch self {
        case .bus(let bus):
            return "bus-\(bus.id)"
        case .stop(let route):
            return "stop-\(route.id)"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .bus(let bus):
            return bus.coordinate
        case .stop(let route):
            return CLLocationCoordinate2D(latitude: route.location.lat, longitude: route.location.lon)
        }
    }
}