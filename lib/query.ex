defmodule ExQL.Query do
  defmacro __using__(_) do
    quote do
      import ExQL.Query
    end
  end

  def statement(_query), do: ""

  defoverridable [statement: 1]
end
