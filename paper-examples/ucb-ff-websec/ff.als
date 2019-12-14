// https://ieeexplore.ieee.org/abstract/document/5552637/
abstract sig NetworkEndpoint {}
abstract sig Event {}

abstract sig NetworkEvent extends Event {
	from: NetworkEndpoint,
	to: NetworkEndpoint
}