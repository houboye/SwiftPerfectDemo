import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

open class NetworkServerManager {
    private var server: HTTPServer
    init(root: String, port: UInt16, routesArr: Array<Dictionary<String, Any>>) {
        server = HTTPServer()
        for dict in routesArr {
            let baseUrl = dict["url"] as! String // host
            let method = dict["method"] as! String // 方法
            var routes = Routes(baseUri: baseUrl) // 创建路由
            let httpMethod = HTTPMethod.from(string: method)
            configure(routes: &routes, method: httpMethod) // 注册路由
            server.addRoutes(routes) // 添加路由至服务器
        }
        server.serverName = "localhost" // 服务器名称
        server.serverPort = port // 端口
        server.documentRoot = root // 根目录
        server.setResponseFilters([(Filter404(), HTTPFilterPriority.high)])
    }
    
    open func startServer() {
        do {
            print("启动HTTP服务器")
            try server.start()
        } catch PerfectError.networkError(let code, let msg) {
            print("网络出现错误：\(code)\(msg)")
        } catch {
            print("未知错误")
        }
    }
    
    private func configure(routes: inout Routes, method: HTTPMethod) {
        routes.add(method: .get, uri: "/selectUserInfor") { (requset, response) in
            let path = requset.path
            print(path)
            let jsonDic = ["hello": "world"]
            let jsonString = self.baseResponseBodyJSONData(code: 200, message: "请求成功", data: jsonDic)
            response.setBody(string: jsonString)
            response.completed()
        }
    }
    
    func baseResponseBodyJSONData(code: Int, message: String, data: Any?) -> String {
        var result = [String: Any]()
        result.updateValue(code, forKey: "code")
        result.updateValue(message, forKey: "message")
        if data != nil {
            result.updateValue(data!, forKey: "data")
        } else {
            result.updateValue("", forKey: "data")
        }
        guard let jsonString = try? result.jsonEncodedString() else {
            return ""
        }
        return jsonString
    }
    
    struct Filter404: HTTPResponseFilter {
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            if case .notFound = response.status {
                response.setBody(string: "404 文件\(response.request.path)不存在。")
                response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
                callback(.done)
            } else {
                callback(.continue)
            }
        }
    }
}
