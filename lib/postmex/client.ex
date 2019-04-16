defmodule Postmex.Client do
  def get_delivery_quote(pickup_address, dropoff_address, client_id \\ nil) do
    url = Postmex.Url.delivery_quote_url(client_id)
    body = {:form, [dropoff_address: dropoff_address, pickup_address: pickup_address]}
    Postmex.post!(url, body, Postmex.auth_header())
  end
end
