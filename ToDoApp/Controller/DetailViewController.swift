//
//  DetailViewController.swift
//  ToDoApp
//
//  Created by Алексей Королев on 01.12.2021.
//

import MapKit
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var mapView: MKMapView!

    var task: Task!

    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        titleLabel.text = task.title
        descriptionLabel.text = task.description
        locationLabel.text = task.location?.name
        dateLabel.text = dateFormatter.string(from: task.date)

        if let coordinate = task.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            mapView.region = region
        }
    }
}
