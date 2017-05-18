## 问题描述：iOS8 系统上WKWebView https 证书不验证问题

### 详细过程：
WKWebView在iOS8上加载https(无效证书)出错，通过各种资料查询是WKWebView没有走证书处理的方法(下面会给出)，更何况证书不符合apple的要求。

### Log输出:
```swift
NSURLConnection/CFURLConnection HTTP load failed (kCFStreamErrorDomainSSL, -9814)
```

### https关于服务器支持要求：
- 服务器必须支持传输层安全(TLS)协议1.2以上版本
- 证书必须使用SHA256或更高的哈希算法签名
- 必须使用2048位以上RSA密钥或256位以上ECC算法等

😄 检测你的地址是否支持ATS->👇👇👇[传送门](https://www.qcloud.com/product/ssl#userDefined10)👇👇👇

### 我目前的处理
- iOS8及以下系统 使用UIWebView
- iOS9及以上系统 使用WKWebView

### 需要注意
iOS8及以下系统，使用UIWebView的时候，任然需要忽略证书（其实这个取决于你们服务端愿不愿去支持ATS）,如果不愿意或者说你跳的第三方根本就无法修改，那还是老老实实的忽略吧，不管那么多了，直接忽略😔😔😔

### 放大招(示例代码)

#### 控件及变量
```swift
// UIWebView 
var webViewIOS8: UIWebView?
var requestIOS8: URLRequest?
// WKWebView
var webViewIOS9: WKWebView?
// Other
var authed: Bool = false
var urlConnection: NSURLConnection?
```

#### 根据系统版本选择控件
```swift
if #available(iOS 9.0, *) {
	let request: URLRequest = URLRequest.init(url: URL.init(string: "链接地址")!)
	view.addSubview(webViewIOS9)
	webViewIOS9.load(request)
}else{
	requestIOS8 = URLRequest.init(url: URL.init(string: "链接地址")!)
	view.addSubview(webViewIOS8)
	webViewIOS8.loadRequest(requestIOS8!)
}
```

#### iOS8及以上忽略证书
```swift
func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
	// 重新赋值requestIOS8
    requestIOS8 = request
    // 判断是否https
    if (requestIOS8?.url?.absoluteString.hasPrefix("https"))! && !authenticated{
        authenticated = false
        // 使用NSURLConnection
        urlConnection = NSURLConnection.init(request: request, delegate: self)
        // 开始
        urlConnection?.start()
        return false
    }
    return true
}

func webViewDidFinishLoad(_ webView: UIWebView) {
	// 控制使用NSURLConnection
    authenticated = (requestIOS8?.url?.absoluteString.hasPrefix("https"))!
}

func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
	// 错误打印    
}

// MARK: NSURLConnectionDelegate
// 我对这部分的理解就是不去验证证书的真伪，直接信任服务端
func connection(_ connection: NSURLConnection, didReceive challenge: URLAuthenticationChallenge) {
	// 创建凭据对象
    let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
    // 告诉服务器信任证书
    challenge.sender?.use(cred, for: challenge)
}

func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
	// 控制使用NSURLConnection
    authenticated = true
    // 重新加载
    webViewIOS8.loadRequest(requestIOS8!)
    // 取消
    urlConnection?.cancel()
}

func connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool {
    return true
}
```


#### iOS9及以上忽略证书
```swift
func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
	// 创建凭据对象
    let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
    // 告诉服务器信任证书
    completionHandler(.useCredential, cred)
}
```

#### 注意
以上内容为个人整理，如果有问题有出入或者你有更好的解决方法，还请赐教哦，感谢。
