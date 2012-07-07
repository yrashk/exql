all: compile

deps/elixir/rel/elixir/bin/elixir:
		@git clone https://github.com/elixir-lang/elixir deps/elixir
		@cd deps/elixir && make release_erl

prepare: deps/elixir/rel/elixir/bin/elixir

compile: prepare
		@ERL_LIBS=deps/elixir/rel/elixir/lib ./rebar compile
