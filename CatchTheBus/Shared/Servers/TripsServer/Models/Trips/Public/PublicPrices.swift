//
//  PublicPrices.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicPrices: Decodable, Equatable {
    let adult: Int
    let child: Int
    let young_child: Int
    let concession: Int
    let seat: Int
    let wheelchair: Int
    let bicycle: Int
}

extension PublicPrices {
    var appModel: AppPrices {
        .init(
            adult: adult,
            child: child,
            youngChild: young_child,
            concession: concession,
            seat: seat,
            wheelchair: wheelchair,
            bicycle: bicycle
        )
    }
}

extension PublicPrices {
    static let test: PublicPrices = .init(
        adult: 850,
        child: 425,
        young_child: 0,
        concession: 0,
        seat: 0,
        wheelchair: 0,
        bicycle: 0
    )
}
