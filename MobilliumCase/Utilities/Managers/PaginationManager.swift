//
//  PaginationManager.swift
//  MobilliumCase
//
//  Created by Murat Çiçek on 16.06.2023.
//

import Foundation

class PaginationManager {

    var pageNo: Int
    var pageSize: Int
    var hasMoreData: Bool
    var isLoading: Bool

    init() {
        self.pageNo = 1
        self.pageSize = 20
        self.hasMoreData = true
        self.isLoading = false
    }

    // MARK: - Update data
    func resetPagination() {
        self.pageNo = 0
        self.hasMoreData = true
        self.isLoading = false
    }

    func fetchedData(count: Int) {
        if count < self.pageSize {
            self.hasMoreData = false
        } else {
            self.pageNo += 1
        }
        self.isLoading = false
    }

    // MARK: - Request state
    func canLoadMore() -> Bool {
        return !isLoading && hasMoreData
    }

    func startedLoading() {
        self.isLoading = true
    }

    func reset() {
        pageNo = 0
        pageSize = 10
        hasMoreData = true
        isLoading = false
    }
}
