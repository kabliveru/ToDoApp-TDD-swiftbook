//  Created by Алексей Королев

@testable import ToDoApp
import XCTest

class TaskManagerTests: XCTestCase {
    var sut: TaskManager!

    override func setUpWithError() throws {
        sut = TaskManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testInitWithZeroTasks() {
        XCTAssertEqual(sut.tasksCount, 0)
    }

    func testInitWithZeroDoneTasks() {
        XCTAssertEqual(sut.tasksCount, 0)
    }

    func testAddingATaskIncrementTasksCount() {
        let task = Task(title: "Task1")
        sut.add(task: task)
        XCTAssertEqual(sut.tasksCount, 1)
    }

    func testTaskAtIndexIsAddedTask() {
        let task = Task(title: "Task1")
        sut.add(task: task)

        let returnedTask = sut.task(at: 0)

        XCTAssertEqual(task.title, returnedTask.title)
    }

    func testCheckTestAtIndexChangesCounts() {
        let task = Task(title: "Task1")
        sut.add(task: task)

        sut.checkTask(at: 0)

        XCTAssertEqual(sut.tasksCount, 0)
        XCTAssertEqual(sut.doneTasksCount, 1)
    }

    func testCheckesTaskAtRemovewFromTasks() {
        let task1 = Task(title: "Task1")
        let task2 = Task(title: "Task2")
        sut.add(task: task1)
        sut.add(task: task2)

        sut.checkTask(at: 0)

        XCTAssertEqual(sut.task(at: 0), task2)
    }

    func testDoneTaskAtReturnsCheckedTask() {
        let task = Task(title: "Task1")
        sut.add(task: task)

        sut.checkTask(at: 0)
        let returnedTask = sut.doneTask(at: 0)

        XCTAssertEqual(returnedTask, task)
    }

    func testRemoveAllResultsCountsbeZero() {
        sut.add(task: Task(title: "task1"))
        sut.add(task: Task(title: "task2"))
        sut.checkTask(at: 0)

        sut.removeAll()

        XCTAssertEqual(sut.tasksCount, 0)
        XCTAssertEqual(sut.doneTasksCount, 0)
    }

    func testAddingTheSameElementsDoesNotIncreaseTheCount() {
        sut.add(task: Task(title: "task"))
        sut.add(task: Task(title: "task"))

        XCTAssertEqual(sut.tasksCount, 1)
    }
}
