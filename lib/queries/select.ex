defrecord ExQL.Select, dict: [fields: :*] do
  use ExQL.Query

  def fields(v, query), do: query.dict Keyword.put(query.dict, :fields, v)
  def from(v, query), do: query.dict Keyword.put(query.dict, :from, v)

  defmacro where(block, query) when is_tuple(block) do
    quote do
      f = fn() ->
        import Elixir.Builtin, except: unquote(ExQL.Condition.__ops__)
        import ExQL.Condition, only: unquote(ExQL.Condition.__ops__)
        unquote(block)
      end
      ExQL.Select._where(f.(), unquote(query))
    end
  end
  defmacro where(value, query) do
    quote do: ExQL.Select._where(unquote(value), unquote(query))
  end
  def _where(v, query), do: query.dict Keyword.put(query.dict, :where, v)

  def statement(:modifiers, query) do
    ExQL.Expression.join(dict(query)[:modifiers], :raw, " ")
  end

  def statement(:fields, query) do
    ExQL.Expression.join(dict(query)[:fields], :raw, ",")
  end

  def statement(:from, query) do
    ["FROM", ExQL.Expression.join(dict(query)[:from], :raw, ",")]
  end

  def statement(:where, query) do
    case dict(query)[:where] do
      nil -> nil
      conds -> ["WHERE", ExQL.Expression.join(conds, :value, "AND")]
    end
  end

  def statement(:group, query) do
    case dict(query)[:group] do
      nil -> nil
      group_by -> ["GROUP BY", ExQL.Expression.join(group_by, :raw, ",")]
    end
  end

  def statement(query) do
    ["SELECT", statement(:modifiers, query), statement(:fields, query),
    statement(:from, query), statement(:where, query), statement(:group, query)] /> ExQL.Utils.space
  end
end

defimpl Binary.Inspect, for: ExQL.Select do 
  def inspect(thing), do: statement(thing.statement, [])

  defp statement([], acc), do: iolist_to_binary(List.reverse(acc))
  defp statement([{:value, value}|rest], acc) do
    statement(rest, [Binary.Inspect.inspect(value)|acc])
  end
  defp statement([list|rest], acc) when is_list(list) do
    new_acc = statement(list, [])
    statement(rest, [new_acc|acc])
  end
  defp statement([head|rest], acc) do
    statement(rest, [head|acc])
  end

end