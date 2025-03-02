//
//  AppScheduleModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppScheduleModel: Decodable, Hashable, Equatable {
    let scheduled: String
    let actual: String?
    let estimated: String?
}

extension AppScheduleModel {
    static var depTest1: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:00:00+00:00",
            actual: "2025-03-01T15:04:02+00:00",
            estimated: "2025-03-01T15:01:24+00:00"
        )
    }
    
    static var arrTest1: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:00:00+00:00",
            actual: "2025-03-01T15:00:47+00:00",
            estimated: "2025-03-01T15:01:24+00:00"
        )
    }
    
    static var depTest2: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:09:00+00:00",
            actual: nil,
            estimated: "2025-03-01T15:11:02+00:00"
        )
    }
    
    static var arrTest2: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:09:00+00:00",
            actual: nil,
            estimated: "2025-03-01T15:11:02+00:00"
        )
    }
    
    static var depTest3: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:14:00+00:00",
            actual: "2025-03-01T15:16:57+00:00",
            estimated: "2025-03-01T15:16:16+00:00"
        )
    }
    
    static var arrTest3: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:14:00+00:00",
            actual: "2025-03-01T15:16:27+00:00",
            estimated: "2025-03-01T15:16:16+00:00"
        )
    }
    
    static var depTest4: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:16:00+00:00",
            actual: "2025-03-01T15:19:20+00:00",
            estimated: "2025-03-01T15:18:51+00:00"
        )
    }
    
    static var arrTest4: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:16:00+00:00",
            actual: "2025-03-01T15:18:58+00:00",
            estimated: "2025-03-01T15:18:51+00:00"
        )
    }
    
    static var depTest5: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:19:00+00:00",
            actual: "2025-03-01T15:22:54+00:00",
            estimated: "2025-03-01T15:22:20+00:00"
        )
    }
    
    static var arrTest5: AppScheduleModel {
        .init(
            scheduled: "2025-03-01T15:19:00+00:00",
            actual: "2025-03-01T15:22:28+00:00",
            estimated: "2025-03-01T15:22:20+00:00"
        )
    }
}
