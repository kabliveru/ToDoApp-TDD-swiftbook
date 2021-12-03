//
//  TaskCellTests.swift
//  ToDoAppTests
//
//  Created by Алексей Королев on 01.12.2021.
//

@testable import ToDoApp
import XCTest

class TaskCellTests: XCTestCase {
    var cell: TaskCell!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as! TaskListViewController
        controller.loadViewIfNeeded()

        let tableView = controller.tableView
        let dataSource = FakeDataSource()
        tableView?.dataSource = dataSource

        cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as? TaskCell
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCellHasTitleLabel() {
        XCTAssertNotNil(cell.titleLabel)
    }

    func testCellHasTitleLabelInContentView() {
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }

    func testCellHasLocationLabel() {
        XCTAssertNotNil(cell.locationLabel)
    }

    func testCellHasLocationLabelInContentView() {
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }

    func testCellHasDateLabel() {
        XCTAssertNotNil(cell.dateLabel)
    }

    func testCellHasDateLabelInContentView() {
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }

    func testConfigureSetsTitle() {
        let task = Task(title: "task1")
        cell.configure(withTask: task)

        XCTAssertEqual(cell.titleLabel.text, task.title)
    }

    func testConfigureSetsLocationName() {
        let location = Location(name: "location1")
        let task = Task(title: "task1", location: location)
        cell.configure(withTask: task)

        XCTAssertEqual(cell.locationLabel.text, task.location?.name)
    }

    func testConfigureSetsDate() {
        let task = Task(title: "task1")
        cell.configure(withTask: task)
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let dateString = df.string(from: task.date)

        XCTAssertEqual(cell.dateLabel.text, dateString)
    }

    func configureCellWithTask() {
        let task = Task(title: "task1")
        cell.configure(withTask: task, done: true)

    }
    
    func testDoneTaskShouldStrikeThrough() {
        configureCellWithTask()
        let attributeString = NSAttributedString(string: "task1", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])

        XCTAssertEqual(cell.titleLabel.attributedText, attributeString)
    }

    func testDoneTaskDateLabelEqualsNil() {
        configureCellWithTask()

        XCTAssertNil(cell.dateLabel)
    }

    func testDoneTaskLocationLabelEqualsNil() {
        configureCellWithTask()

        XCTAssertNil(cell.locationLabel)
    }
}

extension TaskCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            UITableViewCell()
        }
    }
}
