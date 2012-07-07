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

  def statement(:group, query) do
    case group(query) do
      [] -> nil
      group_by -> ["GROUP BY", ExQL.Expression.join(group_by, :raw, ", ")]
    end
  end

  def statement(query) do
    ["SELECT", statement(:modifiers, query), statement(:fields, query),
    statement(:from, query), statement(:where, query), statement(:group, query)] /> ExQL.Utils.space
  end
end
