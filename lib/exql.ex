defmodule ExQL do
  defmacro __using__(_) do
    quote do
      import ExQL
    end
  end

  defmacro select(options // []) do
    quote do
      ExQL.Select.new(unquote(options))
    end
  end

  defmacro expr(c) do
    quote do
      f = fn() ->
        import Elixir.Builtin, except: unquote(ExQL.Condition.__ops__)
        import ExQL.Condition, only: unquote(ExQL.Condition.__ops__)
        unquote(c)
      end
      f.()
   end
  end
  
end