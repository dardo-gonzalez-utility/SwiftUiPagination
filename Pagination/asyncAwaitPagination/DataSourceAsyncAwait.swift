import Foundation

open class DataSourceAsyncAwait<T: Identifiable> {
    
    private var page = 1
    private let pageSize: Int
    private var totalCount = -1
    private var retrievedIds: [T.ID] = []
    
    func fetchRequest(after: Int, first: Int) async throws -> DataSourcePage<T> {
        fatalError("Fetch method not implemented")
    }

    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    func retrieveNextPage() async throws -> [T] {
        if !shouldRetrieveNextPage() { return [] }
        let dataSourcePage = try await fetchRequest(after: page - 2, first: pageSize)
        page += 1
        totalCount = dataSourcePage.totalCount // totalCount may vary between subsequent calls because new items can be added in the BE
        return processPage(page: dataSourcePage.page)
    }
    
    private func shouldRetrieveNextPage() -> Bool {
        totalCount < 0 ? true : page * pageSize < totalCount
    }

    // If new items are added in the BE between subsequent calls, this can result in getting
    // again a previously obtained item in the next requested page. To avoid duplicating it
    // we check them with the already retrieved ids
    private func processPage(page: [T]) -> [T] {
        let newItems = page.filter { !retrievedIds.contains($0.id) }
        retrievedIds.append(contentsOf: newItems.map { $0.id} )
        return newItems
    }
}
