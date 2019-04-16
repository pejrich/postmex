defmodule Postmex do
  use Application
  use HTTPoison.Base

  @api_url "https://api.postmates.com/"
  @api_version "v1/"
  @expected_fields ~w(
    fee currency dropoff_eta duration expires
    properties features
    status complete pickup_eta 
    dropoff_deadline quote_id customer_signature_img_href
    manifest dropoff_identifier courier related_deliveries
  )

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    opts = [strategy: :one_for_one, name: Postmex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def process_response_body(body) do
    Jason.decode!(body)
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
