defmodule ExQL do
  defmacro __using__(_) do
    quote do
      import ExQL
    end
  end

  defmacro expr(block) do
    quote do
      try do
        import Elixir.Builtin, except: unquote(ExQL.Condition.__ops__)
        import ExQL.Condition, only: unquote(ExQL.Condition.__ops__)
        unquote(block)
      end
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
                    [i] -> [(quote do: ExQL.Utils.back_pipeline(unquote(i), unquote(expr)))]
                    _ -> [expr|acc]
                  end
                end)
    case body do
      [] -> quote do: unquote(query) 
      [expr] -> 
        quote do
          try do
            import ExQL.Select
            require ExQL.Utils
            ExQL.Utils.back_pipeline(unquote(query), unquote(expr))
          end
        end
      [l,r] -> 
        quote do
          try do
            import ExQL.Select
            require ExQL.Utils
            ExQL.Utils.back_pipeline(unquote(query), ExQL.Utils.back_pipeline(unquote(l), unquote(r)))
          end
        end
    end
  end
  
end