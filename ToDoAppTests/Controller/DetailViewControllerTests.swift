//
//  DetailViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Алексей Королев on 01.12.2021.
//

import CoreLocation
@testable import ToDoApp
import XCTest

class DetailViewControllerTests: XCTestCase {
    var sut: DetailViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testHasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }

    func testHasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func testHasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    func testHasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }

    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
    
    func setupTaskAndAppearanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.4792046, longitude: 37.3273304)
        let location = Location(name: "location1", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1606927300)
        let task = Task(title: "task1", description: "description1", date: date, location: location)
        sut.task = task
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func testSettingTaskSetsTitleLabel() {
        setupTaskAndAppearanceTransition()

        XCTAssertEqual(sut.titleLabel.text, "task1")
    }
    
    func testSettingTaskSetsDescriptionLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.descriptionLabel.text, "description1")
    }
    
    func testSettingTaskSetsLocationLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.locationLabel.text, "location1")
    }
    
    func testSettingTaskSetsDateLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.dateLabel.text, "02.12.20")
    }
    
    func testSettingTaskSetsMapView() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 55.4792046, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 37.3273304, accuracy: 0.001)
    }
}
