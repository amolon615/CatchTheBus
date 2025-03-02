//
//  PublicCoordinateModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicCoordinateModel: Decodable, Equatable {
    let latitude: Double
    let longitude: Double
}

extension PublicCoordinateModel {
    var appModel: AppCoordinateModel {
        AppCoordinateModel(
            latitude: latitude,
            longitude: longitude
        )
    }
}

extension PublicCoordinateModel {
    static let testCoordinates1: [PublicCoordinateModel] = [
        .init(latitude: 56.459542218608334, longitude: -2.966276800467473),
        .init(latitude: 56.459116641801984, longitude: -2.96554414986868),
        .init(latitude: 56.459542218608334, longitude: -2.965733748522858),
        .init(latitude: 56.45942485291969, longitude: -2.9664919017183045),
        .init(latitude: 56.459542218608334, longitude: -2.966276800467473)
    ]
    
    static let testCoordinates2: [PublicCoordinateModel] = [
        .init(latitude: 56.46256507145948, longitude: -3.0550262330871196),
        .init(latitude: 56.462403053205456, longitude: -3.0547294020652775),
        .init(latitude: 56.46270436715984, longitude: -3.0541500449180607),
        .init(latitude: 56.462859468797895, longitude: -3.054468333612022),
        .init(latitude: 56.46256507145948, longitude: -3.0550262330871196)
    ]
    
    static let testCoordinates3: [PublicCoordinateModel] = [
        .init(latitude: 56.457394470261235, longitude: -3.1286752219602927),
        .init(latitude: 56.45716919447582, longitude: -3.128925561904907),
        .init(latitude: 56.456884633679266, longitude: -3.1281888482772047),
        .init(latitude: 56.457157337818515, longitude: -3.1278240678511793),
        .init(latitude: 56.457394470261235, longitude: -3.1286752219602927)
    ]
    
    static let testCoordinates4: [PublicCoordinateModel] = [
        .init(latitude: 56.44792778370844, longitude: -3.169394731085048),
        .init(latitude: 56.447749890193236, longitude: -3.1689512727461984),
        .init(latitude: 56.445903701655475, longitude: -3.171147107641445),
        .init(latitude: 56.44614090434802, longitude: -3.171762228012084),
        .init(latitude: 56.44792778370844, longitude: -3.169394731085048)
    ]
}
