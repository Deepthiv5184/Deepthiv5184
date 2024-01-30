//
//  SchoolViewModelTest.swift
//  SampleTestTests
//
//  Created by DEEPTHI on 30/01/24.
//

import XCTest
import Combine
@testable import SampleTest

@MainActor final class SchoolViewModelTest: XCTestCase {
    let  schoolViewModel:SchoolViewModel = SchoolViewModel(serviceManager: MockWebService())
    private let isloadingExpectation = XCTestExpectation(description: "isLoading true")
    private var cancellable: AnyCancellable?

    func getTestNames() async{
        
        await schoolViewModel.fetchDataFromApi()
        
        cancellable = schoolViewModel.objectWillChange.eraseToAnyPublisher().sink { _ in
            XCTAssertNotNil(self.schoolViewModel.schoolNames)
            self.isloadingExpectation.fulfill()
        }
        wait(for: [isloadingExpectation], timeout: 1)
    }
}



