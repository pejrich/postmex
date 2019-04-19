defmodule Postmex.Client do
  def get_delivery_quote(pickup_address, dropoff_address, client_id \\ nil) do
    url = Postmex.Url.delivery_quote_url(client_id)
    body = {:form, [dropoff_address: dropoff_address, pickup_address: pickup_address]}
    Postmex.post!(url, body, Postmex.auth_header())
  end

  def create_delivery(attrs \\ %{}) do
    case Postmex.Delivery.new(attrs) do
      {:ok, delivery} ->
        url = Postmex.Url.create_delivery_url()
        form = {:form, Postmex.Delivery.dump(delivery)}
        Postmex.post!(url, form, Postmex.auth_header())

      {:error, errors} ->
        {:error, errors}
    end
  end

  def cancel_delivery(delivery_id, client_id \\ nil) do
    url = Postmex.Url.cancel_delivery_url(delivery_id, client_id)
    Postmex.post!(url, [], Postmex.auth_header())
  end
end
