import Foundation

class DataSourcePage<T> {
    let totalCount: Int
    let page: [T]
    
    init(totalCount: Int, page: [T]) {
        self.totalCount = totalCount
        self.page = page
    }
}
