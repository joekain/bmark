defmodule Bmark do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: :macros
    end
  end

  defmacro bmark(name, [do: body]) do
    quote bind_quoted: binding do
      Bmark.add_bmark(__ENV__.module, name)
      def unquote(name)(), do: unquote(body)
    end
  end

  def add_bmark(module, name) do
    with_runs(module, fn
      runs -> Bmark.Server.add(module, name, runs)
    end)
  end

  defp with_runs(module, f) do
    runs = case Module.get_attribute(module, :runs) do
      nil -> 10
      val -> val
    end

    f.(runs)
  end
end
