//
//  POIDataService.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 18/08/22.
//

import Foundation

class POIDataService: ObservableObject{
    
    let key = "JdTQmD6Vo99ZMfLPPMBsbtxU91gmZNtq" // <--- TYPE YOUR KEY HERE
    let secret =  "kpZRN5besFxi0VnA" // <-- TYPE YOUR SECRET HERE
    var accessToken:String?
    static let instance = POIDataService()
    
    @Published var pois:DataModel?
    @Published var amadeusError:ErrorModel?
    @Published var amadeusTokenError:AmadeusTokenError?

    private init() {}
    
    func clearResults(){
        pois = nil
        amadeusError = nil
        amadeusTokenError = nil
    }
    
    func buildTokenRequest()->URLRequest?{
        guard let url = URL(string: "https://test.api.amadeus.com/v1/security/oauth2/token") ,
              let data = "grant_type=client_credentials&client_id=\(key)&client_secret=\(secret)".data(using: .utf8)
        else { return nil }
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        return request
    }
    
    func getAccessToken(request:URLRequest?) async -> String?{
        guard let request = request else { return nil }
        do{
            let (resultData, _) = try await URLSession.shared.data(for: request)
            let str = String(decoding: resultData, as: UTF8.self)
            print("\(str)")
            let decoder = JSONDecoder()
            let result:Decodable
            decoder.dateDecodingStrategy = .iso8601
            if str.contains("error"){
                result = try decoder.decode(AmadeusTokenError.self, from: resultData)
                DispatchQueue.main.async {
                    self.amadeusTokenError = result as? AmadeusTokenError
                }
            } else {
                let auth = try decoder.decode(Auth.self, from: resultData)
                return auth.access_token
            }
        } catch {
            print("\(request)")
            print("\(error).")
        }
        return nil
    }
    
    func buildURL(latitude:Double, longitude:Double)->URL?{
        let uc = NSURLComponents()
        uc.scheme = "https"
        uc.host = "test.api.amadeus.com"
        uc.path = "/v1/reference-data/locations/pois"
        uc.queryItems = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            URLQueryItem(name: "radius", value: "10")
        ]
        print(uc.url!.absoluteString)
        return uc.url
    }
    
    func buildRequest(latitude:Double, longitude:Double) async -> URLRequest?{
        guard let url = buildURL(latitude:latitude, longitude:longitude) else { return nil  }
        if  accessToken == nil {
            if let accessToken = await getAccessToken(request: buildTokenRequest()) {
                var request = URLRequest(url:url)
                request.setValue("application/vnd.amadeus+json", forHTTPHeaderField: "accept")
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization" )
                return request
            }
        }
        return nil
    }
    
    func loadPointsOfInterest(latitude:Double, longitude:Double) async {
        guard let request = await buildRequest(latitude: latitude, longitude: longitude) else { return }
        do {
            let (POIData, _) = try await URLSession.shared.data(for: request)
            let str = String(decoding: POIData, as: UTF8.self)
            print("\(str)")
            let decoder = JSONDecoder()
            let result:Decodable
            if str.contains("errors"){
                result = try decoder.decode(ErrorModel.self, from: POIData)
                DispatchQueue.main.async {
                    self.amadeusError = result as? ErrorModel
                }
            } else {
                result = try decoder.decode(DataModel.self, from: POIData)
                DispatchQueue.main.async {
                    self.pois = result as? DataModel
                }
            }
        } catch {
            print("\(error).")
        }
        return
    }
}
