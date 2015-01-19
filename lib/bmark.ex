defmodule Bmark do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: :macros
    end
  end

  defmacro bmark(name, [do: body]) do
    add_bmark(__CALLER__.module, name)
    quote do
      def unquote(name)(), do: unquote(body)
    end
  end

  defp add_bmark(module, name) do
    Bmark.Server.add(module, name)
  end
end
