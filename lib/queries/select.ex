defrecord ExQL.Select, [fields: :*, 
                        from: [],
                        modifiers: [],
                        joins: [],
                        where: [],
                        order: [],
                        aliases: [],
                        group: []
                        ] do
  use ExQL.Query

  def statement(:modifiers, query) do
    ExQL.Expression.join(modifiers(query), :raw, " ")
  end

  def statement(:fields, query) do
    ExQL.Expression.join(fields(query), :raw, ", ")
  end

  def statement(:from, query) do
    ["FROM", ExQL.Expression.join(from(query), :raw, ", ")]
  end

  def statement(:where, query) do
    case where(query) do
      [] -> nil
      conds -> ["WHERE", ExQL.Expression.join(conds, :value, " AND ")]
    end
  end

  def statement(query) do
    ExQL.Utils.space(
    ["SELECT", statement(:modifiers, query), statement(:fields, query),
    statement(:from, query), statement(:where, query)])
  end
end
