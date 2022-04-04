//
//  TeamImage.swift
//  TeamChallenge
//
//  Created by carl on 4/3/22.
//

import Foundation
import UIKit

class TeamImage {

    // Custom URL cache with 1 GB disk storage, 100 MB memory
    static var cache: URLCache = {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("ImageDownloadCache")
        let cache = URLCache(memoryCapacity: 100_000_000, diskCapacity: 1_000_000_000, directory: diskCacheURL)
        debugPrint("Cache path: \(diskCacheURL.path)")
        return cache
    }()

    // Custom URLSession that uses our cache
    static var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        return URLSession(configuration: config)
    }()


    class func preload(_ urlString: String) {
        getImage(remoteURL: urlString) { image in
            // ignore image return
        }
    }

    class func getImage(remoteURL: String, completion: @escaping (UIImage?) -> Void) {
        let URL = URL(string: remoteURL)!
        let request = URLRequest(url: URL)
        let dataTask = session.dataTask(with: request) { data, response, error in
            // debugPrint("Data Task complete")

            if let response = response, let data = data,
               self.cache.cachedResponse(for: request) == nil {
                // Store data in cache
                self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)

                // return image via completion
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
            else {
                if let data = data
                {
                    if let image = UIImage(data: data) {
                        completion(image)
                    }

                }
            }
        }
        dataTask.resume()
    }
}


