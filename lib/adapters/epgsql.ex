defmodule ExQL.Adapter.EPgSQL do
  use ExQL.Adapter
  alias :pgsql, as: PG
  def statement([], acc, values), do: {iolist_to_binary(List.reverse(acc)), List.reverse(values)}
  def statement([{:value, value}|rest], acc, values) do
    statement(rest, ["$" <> to_binary(length(values) + 1)|acc], [value|values])
  end
  def statement([list|rest], acc, values) when is_list(list) do
    {new_acc, new_values} = statement(list, [], values)
    statement(rest, [new_acc|acc], new_values)
  end
  def statement([head|rest], acc, values) do
    statement(rest, [head|acc], values)
  end

  def query(conn, query) do
    {q, params} = ExQL.Adapter.EPgSQL.statement(query)
    process_result PG.equery(conn, q, params)
  end

  defp process_result({:ok, cols, rows}) do
    lc row inlist rows do
      Keyword.from_enum(List.zip((lc {:column, col, _, _, _, _} inlist cols, do: binary_to_atom(col)), row))
    end
  end
end