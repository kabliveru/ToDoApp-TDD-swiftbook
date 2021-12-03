//
//  DataProviderTests.swift
//  ToDoAppTests
//
//  Created by Алексей Королев on 29.11.2021.
//

import XCTest
@testable import ToDoApp

class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    var tableView: UITableView!
    var controller: TaskListViewController!
    
    override func setUpWithError() throws {
        sut = DataProvider()
        sut.taskManager = TaskManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as? TaskListViewController
        
        controller.loadViewIfNeeded()
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfSectionsIsTwo() {
        let numberOfSections = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func testNumberOfRowsInSetion0IsTaskCount() {
        
        sut.taskManager?.add(task: Task(title: "task1"))
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)

        sut.taskManager?.add(task: Task(title: "task2"))
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfRowsInSetion1IsDoneTasksCount() {
        
        sut.taskManager?.add(task: Task(title: "task1"))
        sut.taskManager?.checkTask(at: 0)

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)

        sut.taskManager?.add(task: Task(title: "task2"))
        sut.taskManager?.checkTask(at: 0)
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRowAtIndexPathReturnsTaaskCell() {
        sut.taskManager?.add(task: Task(title: "task1"))
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        let mockTableView = MockTableView.mockTableView(WithDataSource: sut)

        sut.taskManager?.add(task: Task(title: "task1"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(item: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellIsDequeueded)
    }
    
    
    func testCellForRowInSection0CallsConfigure() {
        let mockTableView = MockTableView.mockTableView(WithDataSource: sut)

        let task = Task(title: "task1")
        sut.taskManager?.add(task: task)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    
    func testCellForRowInSection1CallsConfigure() {
        let mockTableView = MockTableView.mockTableView(WithDataSource: sut)
        
        let task1 = Task(title: "task1")
        let task2 = Task(title: "task2")
        sut.taskManager?.add(task: task1)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(item: 0, section: 1)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task1)
    }
    
    func testDeliteButtonTitleSection0ShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(buttonTitle, "Done")
    }
    
    func testDeliteButtonTitleSection1ShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(item: 0, section: 1))
        
        XCTAssertEqual(buttonTitle, "Undone")
    }
    
    func testCheckingTaskChecksInTaskManager() {
        let task = Task(title: "task1")
        sut.taskManager?.add(task: task)
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }

    func testUncheckingTaskUnchecksInTaskManager() {
        let task = Task(title: "task1")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(item: 0, section: 1))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
    
}

extension DataProviderTests {
    class MockTableView: UITableView {
        var cellIsDequeueded = false
        
        static func mockTableView(WithDataSource dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 818))
            mockTableView.dataSource = dataSource
            mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            return mockTableView
        }
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeueded = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
    
    class MockTaskCell: TaskCell {
        var task: Task?
        
        override func configure(withTask task: Task, done: Bool = false) {
            self.task = task
        }
    }
}
