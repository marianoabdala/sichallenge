import Foundation

struct Request {
    
    static func request(urlString: String, on urlSession: URLSession, completionHandler: (Data) -> (), errorHandler: (message: String) -> ()) {
        
        guard let requestURL = URL(string: urlString) else {
            
            errorHandler(message: "An error occurred formatting the fetch URL: \(urlString)")
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            
            guard let _ = response else {
                
                errorHandler(message: "Please check your internet connection. Server may be down.")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                
                errorHandler(message: "Invalid server response type.")
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard statusCode == 200 else {
                
                errorHandler(message: "Invalid response code: \(statusCode)")
                return
            }
            
            guard let data = data else {
                
                errorHandler(message: "Invalid response Data (empty).")
                return
            }
            
            completionHandler(data)
        }
        
        dataTask.resume()
    }
}
