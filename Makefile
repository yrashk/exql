all: compile 

deps/elixir/rel/elixir/bin/elixir:
		@git clone https://github.com/elixir-lang/elixir deps/elixir
		@cd deps/elixir && git checkout 7e068aca85f9528bebe210781ac584214e9b794d
		@cd deps/elixir && make release_erl

prepare: deps/elixir/rel/elixir/bin/elixir 

compile:
		@ERL_LIBS=`pwd`/deps/elixir/rel/elixir/lib ./rebar compile

iex: prepare
		@ERL_LIBS=deps `pwd`/deps/elixir/rel/elixir/bin/iex -pa ebin
