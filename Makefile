DEV_ROCKS = busted luacov luacov-coveralls luacheck

.PHONY: install dev clean doc lint test coverage

install:
	luarocks make kong-dynamic-upstream-*.rockspec \

dev: install
	@for rock in $(DEV_ROCKS) ; do \
		if ! command -v $$rock > /dev/null ; then \
			echo $$rock not found, installing via luarocks... ; \
			luarocks install $$rock ; \
		else \
			echo $$rock already installed, skipping ; \
		fi \
	done;

clean:
	@rm -f luacov.*

doc:
	@ldoc -c config.ld kong

lint:
	@luacheck -q . \
		--std 'ngx_lua+busted' \
		--globals '_KONG' \
		--globals 'ngx' \
		--no-redefined \
		--no-unused-args

test:
	@busted -v spec

coverage:
	@rm -f luacov.*
	@busted --coverage spec/
	@luacov -c spec/.luacov
	@tail -n 1 luacov.report.out | awk '{ print $$3 }'
