defmodule ExQL do
  def select(options // []) do
    ExQL.Select.new(options)
  end
end