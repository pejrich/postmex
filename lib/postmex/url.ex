defmodule Postmex.Url do
  @api_key Postmex.api_key()
  @api_url Postmex.api_url()
  @customer_prefix Postmex.customer_prefix()
  @customer_id Postmex.customer_id()

  def delivery_quote_url(customer_id \\ nil) do
    customer_id = customer_id || @customer_id
    @api_url <> @customer_prefix <> customer_id <> "/delivery_quotes"
  end
end
