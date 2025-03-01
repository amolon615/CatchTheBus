final class AppTripsServer: TripServer {
    func fetchTrips() async throws -> MultipleTripInfoDTO {
        .init(quotes: [], min_card_transaction: 0)
    }
    
    func fetchOneTrip(withID id: String) async throws -> PublicTripModel? {
        return nil
    }
}