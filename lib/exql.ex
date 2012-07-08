defmodule ExQL do
  defmacro __using__(_) do
    quote do
      import ExQL
    end
  end

  defmacro select(block // [do: nil]) do
    query = ExQL.Select.new
    case block[:do] do
      {:__block__, _, body} -> :ok
      nil -> body = []
      expr -> body = [expr]
    end      
    body =
    List.reverse(Enum.reduce body, [], 
                fn(expr, acc) ->
                  case acc do
                    [i] -> [{:/>, 0, [i, expr]}]
                    _ -> [expr|acc]
                  end
                end)
    case body do
      [] -> quote do: unquote(query) 
      [expr] -> 
        quote do
          import ExQL.Select
          unquote(query) /> unquote(expr)
        end
      [l,r] -> 
        quote do
          import ExQL.Select
          unquote(query) /> (unquote(l) /> unquote(r))
        end
    end
  end
  
end