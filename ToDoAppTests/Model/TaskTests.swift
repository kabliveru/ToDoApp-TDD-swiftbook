//  Created by Алексей Королев

@testable import ToDoApp
import XCTest

class TaskTests: XCTestCase {
    func testInitTaskWithTitle() {
        let task = Task(title: "Foo")

        XCTAssertNotNil(task)
    }

    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: "Foo", description: "Bar")

        XCTAssertNotNil(task)
    }

    func testWhenGivenTitleSetsTitle() {
        let task = Task(title: "Foo")

        XCTAssertEqual(task.title, "Foo")
    }

    func testWhenGivenDescriptionSetsDescription() {
        let task = Task(title: "Foo", description: "Bar")

        XCTAssertEqual(task.description, "Bar")
    }

    func testTaskInitWithDate() {
        let task = Task(title: "Foo")

        XCTAssertNotNil(task.date)
    }

    func testWhenGivenLocationSetsLocation() {
        let location = Location(name: "Foo")

        let task = Task(title: "Bar", location: location)

        XCTAssertEqual(task.location, location)
    }
}
