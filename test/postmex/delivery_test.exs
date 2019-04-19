defmodule Postmex.DeliveryTest do
  use ExUnit.Case
  alias Postmex.Delivery

  describe "Delivery" do
    test "it should validate required params" do
      assert {:ok, %{}} = Delivery.new(valid_attrs())
    end

    test "it should validate missing params" do
      attrs = Map.merge(valid_attrs(), %{pickup_name: nil})
      assert {:error, _} = Delivery.new(attrs)
    end

    test "it should validate items" do
      attrs = Map.merge(valid_attrs(), %{items: [%{name: "Coffee", quantity: 1, size: :small}]})
      assert {:ok, _} = Delivery.new(attrs)
      attrs = Map.merge(valid_attrs(), %{items: [%{name: "Coffee", quantity: 1, size: :xsmall}]})
      assert {:error, _} = Delivery.new(attrs)
    end

    test "dump should remove nil attrs" do
      delivery()
      |> Delivery.dump()
      |> IO.inspect()
    end
  end

  defp valid_attrs() do
    %{
      pickup_name: "Jane Smith",
      pickup_address: "930 Alabama St. San Francisco",
      pickup_phone_number: "+19253145147",
      dropoff_name: "John Doe",
      dropoff_address: "324 Larkin St. San Francisco",
      dropoff_phone_number: "+19253145147",
      manifest: "1 cup of coffee"
    }
  end

  defp delivery() do
    {:ok, delivery} =
      valid_attrs()
      |> Delivery.new()

    delivery
  end
end
