defmodule Postmex.Delivery do
  use Vex.Struct

  defstruct [
    :manifest_reference,
    :pickup_name,
    :pickup_address,
    :pickup_latitude,
    :pickup_longitude,
    :pickup_phone_number,
    :pickup_business_name,
    :pickup_notes,
    :dropoff_name,
    :dropoff_address,
    :dropoff_latitude,
    :dropoff_longitude,
    :dropoff_phone_number,
    :dropoff_business_name,
    :dropoff_notes,
    :requires_id,
    :requires_dropoff_signature,
    :pickup_ready_dt,
    :pickup_deadline_dt,
    :dropoff_ready_dt,
    :dropoff_deadline_dt,
    quote_id: "",
    manifest: "",
    manifest_items: []
  ]

  validates(:pickup_name, presence: true)
  validates(:pickup_address, presence: true)
  validates(:pickup_phone_number, presence: true)
  validates(:dropoff_name, presence: true)
  validates(:dropoff_address, presence: true)
  validates(:dropoff_phone_number, presence: true)
  validates(:manifest, presence: true)

  def new(attrs \\ %{}) do
    case Map.get(attrs, :items, []) |> process_items() do
      {:error, err} ->
        # Return error if items are invalid
        {:error, err}

      items ->
        # If items are valid, validate rest of the attrs
        attrs = Map.put(attrs, :items, items)

        struct(__MODULE__, attrs)
        |> Vex.validate()
    end
  end

  def dump(%__MODULE__{} = delivery) do
    delivery
    |> Map.from_struct()
    |> Map.to_list()
    |> Enum.reject(fn {_, v} -> v == "" or v == nil end)
  end

  defp process_items(items) when is_list(items) do
    Enum.reduce_while(items, [], fn elem, acc ->
      case Postmex.Item.new(elem) do
        {:ok, item} -> {:cont, [item | acc]}
        {:error, err} -> {:halt, {:error, err}}
      end
    end)
  end
end

defmodule Postmex.Item do
  use Vex.Struct
  defstruct [:name, :quantity, :size]
  validates(:size, inclusion: [:small, :medium, :large, :xlarge])

  def new(attrs \\ %{}) do
    struct(__MODULE__, attrs)
    |> Vex.validate()
  end
end
