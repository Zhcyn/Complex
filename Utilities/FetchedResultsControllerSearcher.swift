//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import CoreData
import UIKit
class FetchedResultsControllerSearcher<T: NSManagedObject>: NSObject, UISearchResultsUpdating {
    var resultsDidUpdate: ((NSFetchedResultsController<T>) -> ())?
    private let frc: NSFetchedResultsController<T>
    private let searchKeyPath: String
    private let debounceBy: TimeInterval?
    private var searchTerm: String?
    init(frc: NSFetchedResultsController<T>, searchKeyPath: String, debounceBy: TimeInterval?) {
        self.frc = frc
        self.frc.fetchRequest.predicate = nil
        self.searchKeyPath = searchKeyPath
        self.debounceBy = debounceBy
    }
    func search(for term: String?) {
        let term = term?.trimmedOrNil
        guard term != searchTerm else { return }
        searchTerm = term
        if let delay = debounceBy,
            searchTerm != nil {
            let action = #selector(performSearch)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: action, object: nil)
            perform(action, with: nil, afterDelay: delay)
        } else {
            performSearch()
        }
    }
    @objc private func performSearch() {
        if let term = searchTerm {
            frc.fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", searchKeyPath, term)
        } else {
            frc.fetchRequest.predicate = nil
        }
        try? frc.performFetch()
        resultsDidUpdate?(frc)
    }
    func updateSearchResults(for searchController: UISearchController) {
        search(for: searchController.searchBar.text)
    }
}
