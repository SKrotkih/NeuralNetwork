//
//  TestPredicting.swift
//  CleverBoardTests
//

import XCTest
@testable import CleverBoard

class TestPredicting: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testViewModel() {
        let viewModel = PredictingViewModel()
        let myOwnImages = [("1", 1), ("2", 2), ("3", 3), ("4", 4), ("5", 5), ("6", 6)]
        myOwnImages.forEach { item in
            if let image = UIImage(named: item.0) {
                runPredictFor(image: image, what: item.1, with: viewModel)
            } else {
                XCTFail("Failed read the \"\(item.0)\" image!")
            }
        }
    }
    
    private func runPredictFor(image: UIImage, what target: Int,   with viewModel: PredictingViewModel) {
        viewModel.predict(image: image) { result in
            switch result {
            case .noimage:
                break
            case .isnottrained:
                XCTAssert(false, "The Neural Network is not trained!")
            case .wrong:
                XCTAssert(false, "Failed recognition to \"\(target)\"!")
            case .success(let index):
                if index == target {
                    print("Success: \(index) is equal to \(target)")
                }
                XCTAssert(index == target, "\(index) isn't equal to \(target)")
            }
        }
    }
    
}
