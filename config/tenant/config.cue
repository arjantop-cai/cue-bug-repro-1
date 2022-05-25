package config

import (
	"github.com/test/test/internal/cue/services:global_config"
	"github.com/test/test/internal/cue/services:common"
	"github.com/test/test/foo/helm/foo:foo"
)

#Config: R={
	tenant: id: string

	auth0: common.#SomeConfig & {
		enabled: bool
		if (enabled) {
			foo: "\(tenant.id)-value"
		}
	}

	charts: {
		"foo": foo.#Values & {
			global: R.global
		}
	}

	global: global_config.#GlobalConfig & {
		auth0: enabled: R.auth0.enabled
	}
}
