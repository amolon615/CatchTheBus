//
//  PublicScheduleModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicScheduleModel: Decodable {
    let scheduled: String
    let actual: String?
    let estimated: String
}

extension PublicScheduleModel {
    var appModel: AppScheduleModel {
        .init(
            scheduled: scheduled,
            actual: actual,
            estimated: estimated
        )
    }
}
