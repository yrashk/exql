defmodule ExQL.Op do
  def __binary__(record, op, name, l,r) do
    quote do
      unquote(record).new op: unquote(op), name: to_binary(unquote(name)), exprs: [unquote(l),unquote(r)]
    end
  end

  defmacro __using__(_) do
    quote do
      import ExQL.Op, only: [infix: 1]
    end
  end

  defmacro infix(ops) do
    arity_ops = lc {op, _} inlist ops, do: {op, 2}
    head =
    quote do
      def __ops__, do: unquote(arity_ops)
    end 
    tail = lc {op, name} inlist ops do 
      quote do
        defmacro unquote(op).(l,r) do
          ExQL.Op.__binary__(unquote(__CALLER__.module), unquote(op), unquote(name), l, r)
        end
      end
    end
    {:__block__, 0, [head|tail]}
   end
end
defrecord ExQL.Condition, op: nil, name: nil, exprs: [] do
  use ExQL.Op
  infix <: "<", <=: "<=", >=: ">=", >: ">", ==: "=", and: "AND", or: "OR"

end

defimpl ExQL.Expression, for: ExQL.Condition do
  def join(condition, type, _delim) do
    delim = ExQL.Condition.name(condition)
    [[_, first]|rest] = lc value inlist ExQL.Condition.exprs(condition), do: [delim, ExQL.Expression.join(value, type, delim)]
    ["(",[first|rest],")"]
  end
end