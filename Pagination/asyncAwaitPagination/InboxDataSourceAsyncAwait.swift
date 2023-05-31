import Foundation

class InboxDataSourceAsyncAwait: DataSourceAsyncAwait<Message> {
    
    private let inboxService = InboxServiceAsyncAwait()
    
    override func fetchRequest(after: Int, first: Int) async throws -> DataSourcePage<Message> {
        return try await inboxService.getMessagesWithAsyncAwait(after: after, first: first)
    }
}
