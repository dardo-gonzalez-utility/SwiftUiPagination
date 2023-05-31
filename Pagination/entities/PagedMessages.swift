import Foundation

class PagedMessages {
    let totalCount: Int
    let page: [Message]
    
    init(totalCount: Int, page: [Message]) {
        self.totalCount = totalCount
        self.page = page
    }
}
