final class ValleyPinning: NSObject, URLSessionDelegate {

    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return }
        let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
        
        if !Valley.hasSSLPinneEnabled {
            let credential:URLCredential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            // Set SSL policies for domain name check
            let policies = NSMutableArray();
            policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
            SecTrustSetPolicies(serverTrust, policies);
            
            // Evaluate server certificate
            var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
            SecTrustEvaluate(serverTrust, &result)
            let isServerTrusted:Bool = result == SecTrustResultType.unspecified || result ==  SecTrustResultType.proceed
            
            // Get local and remote cert data
            guard let cert = certificate else { return }
            let remoteCertificateData:NSData = SecCertificateCopyData(cert)
            guard let localCert = Valley.pinningCertificateData else { return }
            let localCertificate: [Data] = localCert
            
            if (isServerTrusted && localCertificate.contains(where: { remoteCertificateData.isEqual(to: $0) })) {
                let credential:URLCredential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
}
