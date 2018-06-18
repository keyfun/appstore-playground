//
//  SearchViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

class SearchViewModel: BaseViewModel {

    internal var entries = Array<Entry>()
    internal var filterEntries = Array<Entry>() // for search result
    internal var isSearchResult = false

    func getEntriesCount() -> Int {
        return isSearchResult ? filterEntries.count : entries.count
    }

    func getEntries() -> Array<Entry> {
        return isSearchResult ? filterEntries : entries
    }

    func getEntry(index: Int) -> Entry {
        if isSearchResult {
            if index < filterEntries.count {
                return filterEntries[index]
            }
        } else {
            if index < entries.count {
                return entries[index]
            }
        }
        return Entry()
    }

    func search(_ searchText: String) {
        isSearchResult = !searchText.isEmpty

        filterEntries = entries.filter { (entry) -> Bool in
            let lowercasedSearchText = searchText.lowercased()
            
            let name = entry.name?.lowercased() ?? ""
            let cateogry = entry.categoryTerm?.lowercased() ?? ""
            let summary = entry.summary?.lowercased() ?? ""
            let artist = entry.artist?.lowercased() ?? ""
            
            let array = [name, cateogry, summary, artist]
            
            for (_, text) in array.enumerated() {
                if text.contains(lowercasedSearchText) {
                    return true
                }
            }
            
            return false
        }
    }

}
