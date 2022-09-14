//
//  SceneDelegate.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import UIKit
import CoreLocation


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let locationFetcher = LocationFetcher()
    private let markerController = MarkerController()
    private let personLoader: PersonLoader = {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let url = directory.appendingPathComponent("person.store")
        let store = CodablePersonStore(storeURL: url)
        return LocalPersonLoader(store: store)
    }()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {

        window?.rootViewController = ShowPersonLocationsComposer.composeShowPersonLocationUI(locationFetcher: locationFetcher, personLoader: personLoader)
        window?.makeKeyAndVisible()

        
    }
    
  

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

final class ShowPersonLocationsComposer {
      
    static func composeShowPersonLocationUI(locationFetcher: LocationFetcher, personLoader: PersonLoader) -> ShowPersonLocationViewController {
        let markerController = MarkerController()
        let mapViewController = GMMapViewController(markerController: markerController)
        let personListViewController = PersonListViewController()
        locationFetcher.userLocationUpdated = { [weak mapViewController, weak markerController] location  in
            mapViewController?.currentUserLocation = location
            markerController?.currentLocation = location
        }
        mapViewController.onViewDidLoad = { [weak locationFetcher] in
            locationFetcher?.start()
        }
        let containerView = ShowPersonLocationViewController()
        containerView.add(child: personListViewController, container: containerView.personListContainerView)
        containerView.add(child: mapViewController, container: containerView.mapContainerView)
        return containerView
        
    }
    
    private static func adaptPersonListViewControllerToPersonLoader(_ vc: PersonListViewController, personLoader: PersonLoader, markerController: MarkerController) {
        vc.loadData = { [personLoader, weak vc] in
            vc?.display(isLoading: true)
            personLoader.load { res in
                vc?.display(isLoading: false)
                if let persons = try? res.get() {
                    vc?.display(persons.map {
                        makeCellController(person: $0, markerController: markerController)
                    })
                }
            }
            
        }
    }
    
    private static func makeCellController(person: Person, markerController: MarkerController) -> CellController {
        let vm = PersonCellViewModel(name: person.firstName, lastName: person.lastName)
        let personCellController = PersonCellController(viewModel: vm)
        personCellController.selection = { [weak markerController] in
            person.locations.forEach { location in
                markerController?.addMarker(with: location, id: person.id, title: person.firstName)
            }
        }
        
        personCellController.deselection = { [weak markerController] in
            markerController?.deleteMarker(with: person.id)
        }
        let cellController = CellController(id: person.id, personCellController)
        return cellController
    }
}

