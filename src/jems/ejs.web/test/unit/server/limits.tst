/*
    Test HttpServer.limits
 */
require ejs.web

const HTTP = ":" + (App.config.test.http_port || 6700)
load("../utils.es")

server = new HttpServer

server.observe("readable", function (event, request) {
    Timer(10000, function() {
        finalize()
    }).start()
})

server.setLimits({ requests: 1 })

server.listen(HTTP)
Http().get(HTTP)

//  This request should be rejected
http = new Http
http.get(HTTP)

//  Pump events to allow rhe requests to be serviced
App.eventLoop(250)
try {
    //  This should throw because the request limit will prevent the connection from succeeding.
    http.status
    assert(0)
} catch { }

server.close()

