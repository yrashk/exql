defrecord ExQL.Select, [fields: "*", 
                        from: [],
                        modifiers: [],
                        joins: [],
                        where: [],
                        order: [],
                        aliases: [],
                        group: []
                        ] do
  use ExQL.Query
end
