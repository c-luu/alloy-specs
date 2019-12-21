// https://ieeexplore.ieee.org/abstract/document/5552637/
abstract sig Event {}
abstract sig NetworkEndpoint {}

abstract sig NetworkEvent extends Event {
	from: NetworkEndpoint,
	to: NetworkEndpoint
}

abstract sig Origin {}

sig HTTPEvent extends NetworkEvent {
	host: Origin
}

abstract sig Method {}
abstract sig Path {}
abstract sig HTTPRequestHeader {}

sig HTTPRequest extends HTTPEvent {
	method: Method,
	path: Path,
	headers: set HTTPRequestHeader
}

abstract sig HTTPResponseHeader {}

sig HTTPResponse extends HTTPEvent {
	statusCode: Status,
	headers: set HTTPResponseHeader
}

abstract sig DNS {}

abstract sig Principal {
	servers: set NetworkEndpoint,
	dnsLabels: set DNS
}

abstract sig HTTPConformist {}

abstract sig PassivePrincipal extends Principal {
	servers in HTTPConformist
}

abstract sig HTTPClient {}
abstract sig CA {}

abstract sig Browser extends HTTPClient {
	trustedCA: set CA
}

abstract HTTPTransaction {
	request: HTTPRequest,
	response: HTTPResponse
}

sig ScriptContext {
	owner: Origin,
	location: Browser,
	transactions: set HTTPTransaction
}

abstract sig RequestAPI {}
abstract sig XMLHTTPRequest extends RequestAPI {}

fact {
	all areq: HTTPRequest | {
		areq.from in Browser
		hasCookie[areq]
	} implies all acookie: reqCookies[areq] | 
	some aresp: getBrowserTrans[areq].resp | {
		aresp.host.dnslabel = areq.host.dnslabel
		acookie in respCookies[aresp]
		happensBeforeOrdering[aresp, areq]
	}
}

/**
 * Every HTTP transaction has a cause (another transaction, e.g. due to redirect, 
 * or a request API, e.g. XMLHTTPRequest or form element).
 */
 abstract sig FormElement {}
 fact {
	 all t: ScriptContext.transactions | 
	 	t.cause in FormElement implies
		 	t.req.method in GET + POST
 }

/**
 * The `cause` relation lets us construct the set of principals involved in generating
 * a given transaction.
 */
 fun involvedServers [
	 t: HttpTransaction
 ]: set NetworkEndpoint {
	 (t.*cause & HttpTransaction).resp.from + getTransactionOwner[t].servers
 }

 pred webAttackerInCausalChain [t: HttpTransaction] {
	 some (WEBATTACKER.servers & involvedServers[t])
 }