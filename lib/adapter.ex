defmodule ExQL.Adapter do
  defmacro __using__(_) do
    quote do
       def statement(query), do: unquote(__CALLER__.module).statement(query.statement, [], [])
    end
  end
end
