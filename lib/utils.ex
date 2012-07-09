defmodule ExQL.Utils do

  def space([]), do: []
  def space(list) when is_list(list) do
   [[_|first]|last] = lc i inlist Enum.filter(list, fn(x) -> x != nil end), do: [" " , space(i)]
   [first|last]
  end
  def space(string) when is_binary(string), do: string
  def space(other), do: other

  defmacro back_pipeline(left, right) do
    back_pipeline_op(left, right)
  end

  def back_pipeline_op(left, { {:.,_,[{:__aliases__,_,[:ExQL,:Utils]},:back_pipeline]}, _, [middle, right] }) do
    back_pipeline_op(back_pipeline_op(left, middle), right)
  end

  def back_pipeline_op(left, { call, line, atom }) when is_atom(atom) do
    { call, line, [left] }
  end

  def back_pipeline_op(left, { call, line, args }) when is_list(args) do
    { call, line, args ++ [left] }
  end

end