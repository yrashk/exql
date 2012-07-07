defmodule ExQL.Op do
  def __binary__(record, op, l,r) do
    quote do
      unquote(record).new op: unquote(op), exprs: [unquote(l),unquote(r)]
    end
  end
  defmacro __using__(ops) do
    arity_ops = lc op inlist ops, do: {op, 2}
    head =
    quote do
      import ExQL.Op, only: [__binary__: 4]
      def __ops__, do: unquote(arity_ops)
    end 
    tail = lc op inlist ops do 
      quote do
        defmacro unquote(op).(l,r) do
          __binary__(unquote(__CALLER__.module), unquote(op), l, r)
        end
      end
    end
    {:__block__, 0, [head|tail]}
   end
end
defrecord ExQL.Condition, op: nil, exprs: [] do
  use ExQL.Op, [:<, :<=, :>=, :>, :==, :and, :or]

  
  def to_string(type, condition) do
    delim = to_binary(op(condition))
    [[_, first]|rest] = lc value inlist exprs(condition), do: [delim, ExQL.Expression.join(value, type, delim)]
    ["(",[first|rest],")"]
  end

end

defimpl ExQL.Expression, for: ExQL.Condition do
  def join(condition, type, _delim), do: ExQL.Condition.to_string(type, condition)
end