import Foundation

class InboxDataSourceAsyncAwait {
    
    private var page = 1
    private let pageSize: Int
    private var totalCount = -1
    private var retrievedIds: [Int] = []
    private let inboxService = InboxServiceAsyncAwait()
    
    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    func retrieveNextPage() async throws -> [Message] {
        if !shouldRetrieveNextPage() { return [] }
        let pagedMessages = try await inboxService.getMessagesWithAsyncAwait(after: page - 2, first: pageSize)
        page += 1
        totalCount = pagedMessages.totalCount
        return pagedMessages.page
    }
    
    private func shouldRetrieveNextPage() -> Bool {
        totalCount < 0 ? true : page * pageSize < totalCount
    }
}
