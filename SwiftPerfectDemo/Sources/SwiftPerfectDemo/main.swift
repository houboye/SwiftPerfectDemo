import PerfectHTTP
import PerfectHTTPServer

var routesArr = [[String: Any]]()

var rotes1 = ["method": "GET", "url": "/api"]

routesArr.append(rotes1)

let networkServer = NetworkServerManager(root: "webroot", port: 8080, routesArr: routesArr)

networkServer.startServer()
