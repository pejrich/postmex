defmodule Postmex do
  use Application
  use HTTPoison.Base

  @api_url "https://api.postmates.com/"
  @api_version "v1/"
  @expected_fields ~w(
    created currency currency_type dropoff_eta duration expires fee id kind pickup_duration
    properties features status complete pickup_eta dropoff_deadline quote_id
    customer_signature_img_href manifest dropoff_identifier courier related_deliveries
    code message params courier_imminent dropoff dropoff_ready live_mode manifest_items
    pickup pickup_deadline pickup_ready tip tracking_url undeliverable_action
    undeliverable_reason updated
  )

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    opts = [strategy: :one_for_one, name: Postmex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def process_response_body(body) do
    body_keys = Jason.decode!(body) |> Map.keys()

    for key <- body_keys -- @expected_fields do
      IO.puts("\n\nSKIPPING:\n#{inspect(key)}\n\n\n")
    end

    Jason.decode!(body)
    |> Dict.take(@expected_fields)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
  end

  def api_url(), do: @api_url

  def customer_prefix(), do: @api_version <> "customers/"

  def customer_id() do
    Application.get_env(:postmex, :customer_id) || System.get_env("POSTMATES_CUSTOMER_ID")
  end

  def api_key do
    Application.get_env(:postmex, :api_key) || System.get_env("POSTMATES_API_KEY")
  end

  def auth_header() do
    encoded_auth = Base.url_encode64(api_key() <> ":")
    Map.new(Authorization: "Basic " <> encoded_auth)
  end
end
