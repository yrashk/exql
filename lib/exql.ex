defmodule ExQL do

  def select(options // []) when is_list(options) do
    ExQL.Select.new(options)
  end
  def select(fields, options // []) do
    ExQL.Select.new(Keyword.put options, :fields, fields)
  end
end
