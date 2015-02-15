defmodule Bmark do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: :macros
    end
  end

  defmacro bmark(name, options \\ [runs: 10], [do: body]) do
    runs = Keyword.get(options, :runs)
    quote bind_quoted: binding do
      Bmark.Server.add(__ENV__.module, name, runs)
      def unquote(name)(), do: unquote(body)
    end
  end
end
