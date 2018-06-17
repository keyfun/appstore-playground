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
            if let name = entry.name {
                return name.lowercased().contains(searchText.lowercased())
            }
            return false
        }
    }
    
}
