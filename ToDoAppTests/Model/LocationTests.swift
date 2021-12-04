//  Created by Алексей Королев

import CoreLocation
@testable import ToDoApp
import XCTest

class LocationTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testInetSetsName() {
        let location = Location(name: "Foo")

        XCTAssertEqual(location.name, "Foo")
    }

    func testInitCoordinatesAreSet() {
        let coordinate = CLLocationCoordinate2D(
            latitude: 1,
            longitude: 2
        )

        let location = Location(name: "Foo", coordinate: coordinate)

        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
}
