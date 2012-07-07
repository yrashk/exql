defprotocol ExQL.Expression do
  @only [BitString, Number, Atom, List, Record]
  def join(value, type, delim)
end

defimpl ExQL.Expression, for: BitString do
  def join(value, :value, _delim), do: {:value, value}
  def join(value, :raw, _delim), do: %b{'#{value}'}
end

defimpl ExQL.Expression, for: Number do
  def join(value, :value, _delim), do: {:value, value}
  def join(value, :raw, _delim), do: %b{#{value}}
end

defimpl ExQL.Expression, for: Atom do
  def join(nil, _, _delim), do: nil
  def join(value, _, _delim), do: atom_to_binary(value)
end

defimpl ExQL.Expression, for: List do
  def join([], _, _), do: nil
  def join(list, type, delim) do
    [[_, first]|rest] = lc value inlist list, do: [delim, ExQL.Expression.join(value, type, delim)]
    [first|rest]
  end
end