import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        print("constructor called")
    }
    

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now."
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }


    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()
    
    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {

    // Save an array of tasks to UserDefaults (type method)
    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let encodedTasks = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "savedTasks")
        }
    }

    // Retrieve an array of saved tasks from UserDefaults (type method)
    static func getTasks() -> [Task] {
        if let tasksData = UserDefaults.standard.data(forKey: "savedTasks") {
            let decoder = JSONDecoder()
            do {
                var tasks = try decoder.decode([Task].self, from: tasksData)

                return tasks
            } catch {
                print("Error decoding tasks: \(error)")
            }
        }

        return []
    }


    func save() {
        var existingTasks = Task.getTasks()
        
        if let index = existingTasks.firstIndex(where: { $0.id == self.id }) {
            // If the task already exists, update it
            existingTasks[index] = self
        } else {
            // If no matching task already exists, add the new task to the end of the array
            existingTasks.append(self)
        }
        
        Task.save(existingTasks)
    }






}
