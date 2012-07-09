defmodule ExQL.Query do
  defmacro __using__(_) do
    quote do
      import ExQL.Query
    end
  end

  defmacro accessor(name) do
    quote do
      def unquote(name).(v, query), do: query.dict Keyword.put(query.dict, unquote(name), v)
      def unquote(name).(query), do: query.dict[unquote(name)]
    end
  end

  def statement(_query), do: ""

  defoverridable [statement: 1]
end
