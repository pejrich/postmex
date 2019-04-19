defmodule Postmex.Webhooks do
  import Plug.Conn

  def init(opts) do
    raw = Keyword.get(opts, :raw, false)

    handler =
      Keyword.get(opts, :handler) ||
        raise ArgumentError, "Postmex.Webhooks - :handler option not supplied"

    %{raw: raw, handler: handler}
  end

  def call(conn, opts) do
    evt = format_params(conn.params, opts[:raw])

    case opts.handler do
      {m, f, a} -> apply(m, f, [evt] ++ a)
      f when is_function(f) -> f.(evt)
    end

    conn
    |> send_resp(200, "")
    |> halt()
  end

  defp format_params(params, true), do: params

  defp format_params(params, _) do
    kind = params["kind"]
    delivery_id = params["delivery_id"]
    {delivery_id, kind, params}
  end
end
