all: compile 

deps/elixir:
		@./rebar get-deps

compile: deps/elixir
		@ERL_LIBS=`pwd`/deps/elixir/lib ./rebar compile

iex:
		@ERL_LIBS=deps `pwd`/deps/elixir/bin/iex -pa ebin
