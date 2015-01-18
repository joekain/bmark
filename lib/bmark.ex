defmodule Bmark do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: :macros
    end
  end

  defmacro bmark(_name, [do: _body]) do
  end
end
