//
//  RangerApiClient_v1.swift
//
//  Created by Nicholas Cromwell  on 12/12/20.
//

import Alamofire
import Foundation

public final class RangerSwiftApiClientV1 {
    static var instance = RangerSwiftApiClientV1()
    private let encoder = JSONParameterEncoder()
    private let decoder = JSONDecoder()
    private var baseUrl: String = "https://rangerlabs.io/api"
    
    private func getHeaders(apiKey: String) -> HTTPHeaders {
        return [
            "Accept": "application/json",
            "Api-Version": "1.0",
            "X-Ranger-ApiKey": apiKey
        ]
    }
    
    private init() {
        let isoFormatter = DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        encoder.encoder.dateEncodingStrategy = .formatted(isoFormatter)
        decoder.dateDecodingStrategy = .formatted(isoFormatter)
    }
    
    private static func isBreadcrumbApiKey(apiKey: String) -> Bool {
        return apiKey.lowercased().starts(with: "test") || apiKey.lowercased().starts(with: "live")
    }
    
    private static func isProjectApiKey(apiKey: String) -> Bool {
        return apiKey.lowercased().starts(with: "proj")
    }
    
    private func getRequest<T:Codable>(apiKey: String, url: String, completionHandler: @escaping ((RangerApiResponse<T>) -> Void) ) {
        AF.request(url,
                   headers: self.getHeaders(apiKey: apiKey))
         .validate(statusCode: 200...500)
         .responseDecodable(of: RangerApiResponse<T>.self, decoder: self.decoder) { response in
             switch(response.result) {
             case .success(let result):
                 completionHandler(result)
             case .failure(let error):
                 debugPrint(error)
             }
        }
    }
    
    private func postRequest<T:Encodable>(apiKey: String, url: String, body: T, completionHandler: @escaping ((RangerApiResponse<Data>) -> Void) ) {
        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoder: self.encoder,
                   headers: self.getHeaders(apiKey: apiKey))
         .validate(statusCode: 200...500)
         .responseDecodable(of: RangerApiResponse<Data>.self, decoder: self.decoder) { response in
             switch(response.result) {
             case .success(let result):
                 completionHandler(result)
             case .failure(let error):
                 debugPrint(error)
             }
        }
    }
    
    private func putRequest<T:Encodable>(apiKey: String, url: String, body: T, completionHandler: @escaping ((RangerApiResponse<Data>) -> Void) ) {
        AF.request(url,
                   method: .put,
                   parameters: body,
                   encoder: self.encoder,
                   headers: self.getHeaders(apiKey: apiKey))
         .validate(statusCode: 200...500)
         .responseDecodable(of: RangerApiResponse<Data>.self, decoder: self.decoder) { response in
             switch(response.result) {
             case .success(let result):
                 completionHandler(result)
             case .failure(let error):
                 debugPrint(error)
             }
        }
    }
    
    private func deleteRequest(apiKey: String, url: String, completionHandler: @escaping ((RangerApiResponse<Data>) -> Void) ) {
        AF.request(url,
                   method: .delete,
                   headers: self.getHeaders(apiKey: apiKey))
        .validate(statusCode: 200...500)
        .responseDecodable(of: RangerApiResponse<Data>.self, decoder: self.decoder) { response in
             switch(response.result) {
             case .success(let result):
                 completionHandler(result)
             case .failure(let error):
                 debugPrint(error)
             }
        }
    }
    
    public static func SetBaseUrl(url: String) {
        instance.baseUrl = url
    }
    
    //MARK: Breadcrumbs
    public static func PostBreadcrumb(breadcrumb: Breadcrumb, apiKey: String, completionHandler: @escaping ((RangerApiResponse<Data>) -> Void)) throws -> Void {
        if !self.isBreadcrumbApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeLiveOrTestApiKey
        }
        instance.postRequest(apiKey: apiKey, url: "\(instance.baseUrl)/breadcrumbs",
            body: breadcrumb,
            completionHandler: completionHandler)
    }
    
    //MARK: Geofences
    public static func GetGeofenceByExternalId(apiKey: String, externalId: String, completionHandler: @escaping ((RangerApiResponse<Geofence>) -> Void)) throws -> Void {
        if !self.isProjectApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeProjectApiKey
        }
        if externalId.isEmpty {
            throw ApiInputError.externalIdRequired
        }
        
        instance.getRequest(apiKey: apiKey, url: "\(instance.baseUrl)/geofences?externalId=\(externalId)", completionHandler: completionHandler)
    }
    
    //MARK: Geofences
    public static func GetPaginatedGeofences(apiKey: String, search: String = "", sortOrder: SortOrders = .desc, orderBy: OrderByOptions = .createdDate, pageCount: Int = 100, page: Int = 0, completionHandler: @escaping ((RangerApiResponse<[Geofence]>) -> Void)) throws -> Void {
        if !self.isProjectApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeProjectApiKey
        }
        if (pageCount < 1 || pageCount > 1000) {
            throw ApiInputError.pageCountOutOfBounds("Must be between 1 and 1000, inclusive")
        }
        if (page < 0) {
            throw ApiInputError.pageOutOfBounds("Must be greater than or equal to 0")
        }
        
        instance.getRequest(apiKey: apiKey, url: "\(instance.baseUrl)/geofences?search=\(search)&sortOrder=\(sortOrder)&orderBy=\(orderBy)&pageCount=\(pageCount)&page=\(page)", completionHandler: completionHandler)
    }
    
    public static func CreateGeofence(apiKey: String, geofence: Geofence, completionHandler: @escaping ((RangerApiResponse<Data>) -> Void)) throws -> Void {
        if !self.isProjectApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeProjectApiKey
        }

        instance.postRequest(apiKey: apiKey, url: "\(instance.baseUrl)/geofences", body: geofence, completionHandler: completionHandler)
    }
    
    public static func UpdateGeofence(apiKey: String, geofence: Geofence, completionHandler: @escaping ((RangerApiResponse<Data>) -> Void)) throws -> Void {
        if !self.isProjectApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeProjectApiKey
        }
        
        if (geofence.id == nil) {
            throw ApiInputError.idRequired
        }
        
        instance.putRequest(apiKey: apiKey, url:"\(instance.baseUrl)/geofences/\(geofence.id!)" , body: geofence, completionHandler: completionHandler)
   }
    
    public static func DeleteGeofence(apiKey: String, externalId: String, completionHandler: @escaping ((RangerApiResponse<Data>) -> Void)) throws -> Void {
        if !self.isProjectApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeProjectApiKey
        }
        if externalId.isEmpty {
            throw ApiInputError.externalIdRequired
        }
        
        instance.deleteRequest(apiKey: apiKey, url: "\(instance.baseUrl)/geofences/\(externalId)", completionHandler: completionHandler)
    }
    
    public static func BulkDeleteGeofences(apiKey: String, externalIds: [String], completionHandler: @escaping ((RangerApiResponse<Data>) -> Void)) throws -> Void {
        if !self.isProjectApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeProjectApiKey
        }
        if externalIds.isEmpty {
            throw ApiInputError.externalIdCollectionRequired
        }
        let requestBody = try BulkDelete(externalIds: externalIds)
        
        instance.postRequest(apiKey: apiKey, url:"\(instance.baseUrl)/geofences/bulk-delete", body: requestBody, completionHandler: completionHandler)
    }
    
    //MARK: Integrations
    public static func GetIntegrations(apiKey: String, completionHandler: @escaping ((RangerApiResponse<[Integration]>) -> Void)) throws -> Void {
        if !self.isProjectApiKey(apiKey: apiKey) {
            throw InvalidApiKeyError.mustBeProjectApiKey
        }
        instance.getRequest(apiKey: apiKey, url:"\(instance.baseUrl)/integrations", completionHandler: completionHandler)
    }
}
