import Foundation

open class DataSourceAsyncAwait<T> {
    
    private var page = 1
    private let pageSize: Int
    private var totalCount = -1
    private var retrievedIds: [Int] = []
    
    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    func retrieveNextPage() async throws -> [T] {
        if !shouldRetrieveNextPage() { return [] }
        let pagedMessages = try await fetchRequest(after: page - 2, first: pageSize)
        page += 1
        totalCount = pagedMessages.totalCount
        return pagedMessages.page
    }
    
    private func shouldRetrieveNextPage() -> Bool {
        totalCount < 0 ? true : page * pageSize < totalCount
    }

    func fetchRequest(after: Int, first: Int) async throws -> DataSourcePage<T> {
        fatalError("Fetch method not implemented")
    }
}
