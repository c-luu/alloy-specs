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
