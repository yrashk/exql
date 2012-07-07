defmodule ExQL.Utils do

  def space([]), do: []
  def space(list) when is_list(list) do
   [[_|first]|last] = lc i inlist Enum.filter(list, fn(x) -> x != nil end), do: [" " , space(i)]
   [first|last]
  end
  def space(string) when is_binary(string), do: string
  def space(other), do: other

end