package config

import (
	networkingv1 "k8s.io/api/networking/v1"
)

#NetworkPolicy: networkingv1.#NetworkPolicy & {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	metadata: name: string
}

#Flux: R={
	#Config

	charts:     _

	formatOutput: {...}

	_outputs: {...}

	for _chartName, _chartValues in charts {
		_outputs: "\(_chartName)": {}
	}

	_outputs: {
		for ns in ["ns"] {
			"\(ns)/network": #NetworkPolicy & {
				metadata: name: "network-\(ns)"
				spec: {
					ingress: [
						{
							from: [{
								namespaceSelector: matchLabels: {
									tenant: R.tenant.id
								}
							}]
						},
					]
					egress: [
						{
							to: [{
								namespaceSelector: matchLabels: {
									tenant: R.tenant.id
								}
							}]
						},
					]
				}
			}
		}
	}

	for ns in ["ns"] {
		for k, v in _outputs {
			formatOutput: "\(k)": v
		}
	}
}
