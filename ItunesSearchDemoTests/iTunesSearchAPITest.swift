//
//  iTunesSearchAPITest.swift
//  ItunesSearchDemoTests
//
//  Created by Bing Bing on 2022/7/7.
//

import XCTest
import RxSwift
@testable import ItunesSearchDemo

class iTunesSearchAPITest: XCTestCase {
    
    var api: iTunesSearchAPIProtocol!
    var networkDependency: NetworkDependencyProtocol!
    
    private let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.networkDependency = NetworkDependency()
        self.api = iTunesSearchAPI(dependency: networkDependency)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.networkDependency = nil
        self.api = nil
    }

    func testiTunesSearchAPIResult() throws {
        
        var result: [iTunesSearchResult] = []
        var errorCountered: Error?
        
        let expectation = XCTestExpectation(description: "should have results")
        
        api.search(query: "K")
            .map(\.results)
            .subscribe(onNext: { res in
                result = res
                expectation.fulfill()
            }, onError: { error in
                errorCountered = error
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssertNil(errorCountered)
        XCTAssertEqual(result.count, 50)
    }

    func testiTunesSearchProvider() throws {
        
        let urlToTest = URL(string: "https://itunes.apple.com/search?term=jack+johnson")
        
        let expectation = XCTestExpectation(description: "should have same url")
        
        let request = iTunesSearchProvider.search(query: "jack+johnson").request
        
        XCTAssertTrue(request.url == urlToTest)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
