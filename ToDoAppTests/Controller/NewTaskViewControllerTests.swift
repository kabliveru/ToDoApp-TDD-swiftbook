//
//  NewTaskViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Алексей Королев on 03.12.2021.
//

import CoreLocation
@testable import ToDoApp
import XCTest

class NewTaskViewControllerTests: XCTestCase {
    var sut: NewTaskViewController!
    var placemark: MockCLPlacemark!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasTitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    func testHasLocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasAddressTextField() {
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testHasCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }

    func testSaveUsesGeocoderToConvertCoordinateFromAddress() {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "02.12.20")
        
        sut.titleTextField.text = "title1"
        sut.locationTextField.text = "location1"
        sut.dateTextField.text = "02.12.20"
        sut.addressTextField.text = "Москва"
        sut.descriptionTextField.text = "description1"

        sut.taskManager = TaskManager()
        let mocGeocoder = MockCLGeocoder()
        sut.geocoder = mocGeocoder
        sut.save()
        
        let coordinate = CLLocationCoordinate2D(latitude: 55.7615902, longitude: 37.60946)
        let location = Location(name: "location1", coordinate: coordinate)
        let generatedTask = Task(title: "title1", description: "description1", date: date, location: location)
        
        placemark = MockCLPlacemark()
        placemark.mockCoordinate = coordinate
        mocGeocoder.completionHandler?([placemark], nil)

        let task = sut.taskManager?.task(at: 0)
        
        XCTAssertEqual(task, generatedTask)
    }

    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }

}

extension NewTaskViewControllerTests {
    class MockCLGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}
