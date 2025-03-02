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
        let dummyResponse = MultipleTripInfoDTO.test
            
            mockHttpClient.requestHandler = { endpoint in
                return dummyResponse
            }
            
            let fromDate = Date()
            let toDate = Date().addingTimeInterval(3600)
            
            try await tripsServer.fetchTrips(fromDate: fromDate, toDate: toDate)
            
            guard let fetchedTrips = await tripsServer.trips else {
                XCTFail("No trips fetched")
                return
            }
            
            // Both dummyResponse and fetchedTrips now refer to the same type from YourAppModule.
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
        }
    }
    
    func testFetchOneTripSuccess() async throws {
        let dummyPublicTrip = PublicTripModel.test
        
        mockHttpClient.requestHandler = { endpoint in
            return dummyPublicTrip
        }
        
        let result = try await tripsServer.fetchOneTrip(withID: "2")
        let expectedAppTrip = dummyPublicTrip.appModel
        
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
        }
    }
}
