//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Алексей Королев on 29.11.2021.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }

    func configure(withTask task: Task, done: Bool = false) {
        if done {
            let attributeString = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            self.titleLabel.attributedText = attributeString
            self.dateLabel = nil
            self.locationLabel = nil

        } else {
            let dateString = self.dateFormatter.string(from: task.date)
            self.dateLabel.text = dateString
            self.titleLabel.text = task.title
            self.locationLabel.text = task.location?.name
        }
    }
}
