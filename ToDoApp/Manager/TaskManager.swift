//  Created by Алексей Королев

import Foundation

class TaskManager {
    private var tasks: [Task] = []
    private var doneTasks: [Task] = []

    var tasksCount: Int { tasks.count }
    var doneTasksCount: Int { doneTasks.count }

    func add(task: Task) {
        if !tasks.contains(task) {
            tasks.append(task)
        }
    }

    func task(at index: Int) -> Task {
        tasks[index]
    }

    func checkTask(at index: Int) {
        let task = tasks.remove(at: index)
        doneTasks.append(task)
    }

    func uncheckTask(at index: Int) {
        let task = doneTasks.remove(at: index)
        tasks.append(task)
    }

    func doneTask(at index: Int) -> Task {
        doneTasks[index]
    }

    func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
}
