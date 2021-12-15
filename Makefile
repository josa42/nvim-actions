prepare:
	@git submodule update --depth 1 --init

test: prepare
	@nvim \
			--headless \
			--noplugin \
			-u spec/init.vim \
			-c "PlenaryBustedDirectory spec/ { minimal_init = 'spec/init.vim' }"

watch: prepare
	@echo -e '\nRunning tests on "spec/**/*_spec.lua" when any Lua file on "lua/" and "spec/" changes\n'
	@find spec/ lua/ -name '*.lua' | entr make test


