import XCTest
@testable import CatchTheBus

@MainActor
final class MockHTTPClient: HTTPClientProtocol {
    var requestHandler: ((String) async throws -> Any)?
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        accessToken: String? = nil
    ) async throws -> T {
        guard let handler = requestHandler else {
            throw NSError(domain: "MockHTTPClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Handler not set"])
        }
        
        let result = try await handler(endpoint)
        if let typedResult = result as? T {
            return typedResult
        } else {
            throw NSError(domain: "MockHTTPClient", code: -2, userInfo: [NSLocalizedDescriptionKey: "Type mismatch in response"])
        }
    }
}

@MainActor
final class AppTripsServerTests: XCTestCase {
    var mockHttpClient: MockHTTPClient!
    var tripsServer: AppTripsServer!
    
    override func setUp() {
        super.setUp()
        mockHttpClient = MockHTTPClient()
        tripsServer = AppTripsServer(httpClient: mockHttpClient)
    }
    
    override func tearDown() {
        mockHttpClient = nil
        tripsServer = nil
        super.tearDown()
    }
    
    func testFetchTripsSuccess() async throws {
        // Create dummy public data for a quote.
        let dummyAvailability = PublicAvailability(seat: 10, wheelchair: 0, bicycle: 2)
        let dummyPrices = PublicPrices(adult: 850, child: 425, young_child: 0, concession: 0, seat: 0, wheelchair: 0, bicycle: 0)
        
        let dummyLeg = PublicLeg(
            type: "scheduled_transit",
            trip_uid: "dummy_uid",
            adds_capacity_for_trip_uid: nil,
            origin: PublicLocation(
                id: 1,
                atco_code: "ATCO1",
                detailed_name: "Origin Stop",
                lat: 0.0,
                lon: 0.0,
                name: "Origin",
                region_name: "TestRegion",
                type: "STOP",
                code: "CODE1",
                code_detail: "DETAIL1",
                timezone: "UTC",
                heading: 0,
                zone: [],
                has_future_activity: false,
                area_id: 1,
                location_time_id: 1,
                booking_cut_off_mins: 0,
                pre_booked_only: false,
                skipped: false,
                bookable: "Yes"
            ),
            destination: PublicLocation(
                id: 2,
                atco_code: "ATCO2",
                detailed_name: "Destination Stop",
                lat: 1.0,
                lon: 1.0,
                name: "Destination",
                region_name: "TestRegion",
                type: "STOP",
                code: "CODE2",
                code_detail: "DETAIL2",
                timezone: "UTC",
                heading: 0,
                zone: [],
                has_future_activity: false,
                area_id: 2,
                location_time_id: 2,
                booking_cut_off_mins: 0,
                pre_booked_only: false,
                skipped: false,
                bookable: "Yes"
            ),
            departure: PublicScheduleModel(
                scheduled: "2025-03-01T15:00:00+00:00",
                actual: "2025-03-01T15:00:00+00:00",
                estimated: "2025-03-01T15:00:00+00:00"
            ),
            arrival: PublicScheduleModel(
                scheduled: "2025-03-01T15:30:00+00:00",
                actual: "2025-03-01T15:30:00+00:00",
                estimated: "2025-03-01T15:30:00+00:00"
            ),
            description: PublicLegDescription(
                brand: "TestBrand",
                operator: "TestOperator",
                destination_board: "TestBoard",
                number_plate: "TEST123",
                vehicle_type: "bus",
                colour: "blue",
                amenities: PublicAmenities(has_wifi: true, has_toilet: false),
                is_electric: false
            ),
            trip_type: "public"
        )
        
        let dummyQuote = PublicQuote(
            availability: dummyAvailability,
            prices: dummyPrices,
            legs: [dummyLeg],
            bookable: true
        )
        
        let dummyResponse = MultipleTripInfoDTO(
            quotes: [dummyQuote],
            min_card_transaction: 30
        )
        
        mockHttpClient.requestHandler = { endpoint in
            return dummyResponse
        }
        
        let fromDate = Date()
        let toDate = Date().addingTimeInterval(3600)
        
        // Act
        try await tripsServer.fetchTrips(fromDate: fromDate, toDate: toDate)
        
        // Because trips is actor-isolated, capture it using await.
        let fetchedTrips = await tripsServer.trips
        XCTAssertEqual(fetchedTrips, dummyResponse, "Trips should match the dummy response")
    }
    
    func testFetchTripsFailure() async {
        mockHttpClient.requestHandler = { endpoint in
            throw NSError(domain: "TestError", code: 1001, userInfo: nil)
        }
        
        let fromDate = Date()
        let toDate = Date().addingTimeInterval(3600)
        
        do {
            try await tripsServer.fetchTrips(fromDate: fromDate, toDate: toDate)
            XCTFail("Expected an error but did not get one")
        } catch {
            // Expected error thrown.
        }
    }
    
    func testFetchOneTripSuccess() async throws {
        // Construct a dummy PublicTripModel.
        // For the route's location, use PublicLocationModel instead of PublicLocation.
        let dummyPublicTrip = PublicTripModel(
            route: [
                PublicRouteModel(
                    id: AppRouteModel.test.first?.id ?? 0,
                    departure: PublicScheduleModel(
                        scheduled: AppScheduleModel.depTest1.scheduled,
                        actual: AppScheduleModel.depTest1.actual,
                        estimated: AppScheduleModel.depTest1.estimated
                    ),
                    arrival: PublicScheduleModel(
                        scheduled: AppScheduleModel.arrTest1.scheduled,
                        actual: AppScheduleModel.arrTest1.actual,
                        estimated: AppScheduleModel.arrTest1.estimated
                    ),
                    location: PublicLocationModel(
                        id: AppLocationModel.test1.id,
                        type: AppLocationModel.test1.type,
                        name: AppLocationModel.test1.name,
                        region_name: AppLocationModel.test1.regionName,
                        code: AppLocationModel.test1.code,
                        code_detail: AppLocationModel.test1.codeDetail,
                        detailed_name: AppLocationModel.test1.detailedName,
                        direction: nil,
                        lon: AppLocationModel.test1.lon,
                        lat: AppLocationModel.test1.lat,
                        google_place_id: nil,
                        atco_code: AppLocationModel.test1.atcoCode,
                        has_future_activity: true,
                        timezone: AppLocationModel.test1.timezone,
                        zone: [], // Simplified for test.
                        heading: AppLocationModel.test1.heading,
                        area_id: AppLocationModel.test1.areaId
                    ),
                    allow_boarding: AppRouteModel.test.first?.allowBoarding ?? true,
                    allow_drop_off: AppRouteModel.test.first?.allowDropOff ?? false,
                    booking_cut_off_mins: AppRouteModel.test.first?.bookingCutOffMins ?? 0,
                    pre_booked_only: AppRouteModel.test.first?.preBookedOnly ?? false,
                    skipped: AppRouteModel.test.first?.skipped ?? false
                )
            ],
            vehicle: PublicVehicleModel(
                wheelchair: AppVehicleModel.test.wheelchair,
                bicycle: AppVehicleModel.test.bicycle,
                seat: AppVehicleModel.test.seat,
                id: AppVehicleModel.test.id,
                plate_number: AppVehicleModel.test.plateNumber,
                name: AppVehicleModel.test.name,
                has_wifi: AppVehicleModel.test.hasWifi,
                has_toilet: AppVehicleModel.test.hasToilet,
                type: AppVehicleModel.test.type,
                brand: AppVehicleModel.test.brand,
                colour: AppVehicleModel.test.colour,
                is_backup_vehicle: AppVehicleModel.test.isBackupVehicle,
                owner_id: AppVehicleModel.test.ownerId,
                gps: PublicGPSModel(
                    last_updated: AppGPSModel.test.lastUpdated,
                    longitude: AppGPSModel.test.longitude,
                    latitude: AppGPSModel.test.latitude,
                    heading: AppGPSModel.test.heading
                )
            ),
            description: PublicRouteDescriptionModel(
                route_number: AppRouteDescriptionModel.test.routeNumber,
                pattern_id: AppRouteDescriptionModel.test.patternId,
                calendar_date: AppRouteDescriptionModel.test.calendarDate,
                type: AppRouteDescriptionModel.test.type,
                is_cancelled: AppRouteDescriptionModel.test.isCancelled,
                route_id: AppRouteDescriptionModel.test.routeId
            )
        )
        
        mockHttpClient.requestHandler = { endpoint in
            return dummyPublicTrip
        }
        
        // Act
        let result = try await tripsServer.fetchOneTrip(withID: "2")
        let expectedAppTrip = dummyPublicTrip.appModel
        
        // Assert that the converted app trip matches the expected value.
        XCTAssertEqual(result, expectedAppTrip, "Returned trip should match the dummy trip")
    }
    
    func testFetchOneTripFailure() async {
        mockHttpClient.requestHandler = { endpoint in
            throw NSError(domain: "TestError", code: 1002, userInfo: nil)
        }
        
        do {
            _ = try await tripsServer.fetchOneTrip(withID: "nonexistent")
            XCTFail("Expected an error but did not get one")
        } catch {
            // Expected error thrown.
        }
    }
}
