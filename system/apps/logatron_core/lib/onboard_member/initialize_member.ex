defmodule OnboardMember.InitializeMember do
  defmodule Payload do
    use Ecto.Schema

    @moduledoc """
    Payload is the struct that identifies the initial state of a Farm.
    """

    alias Schema.Meta, as: Meta
    alias Schema.Details, as: Details

    @primary_key false
    embedded_schema do
      field(:id, :string)
      embeds_one(:details, Details)
    end
  end

  defmodule Fact do
    use Ecto.Schema

    @moduledoc """
    Fact is a data structure that represents Facts (Events) in the Logatron system.
    """

    alias Schema.Meta, as: Meta

    @primary_key false
    # embedded_schema do
      field(:topic, :string)
      embeds_one(:meta, Meta)
      embeds_one(:payload, Payload)
    end

    def new(topic, meta, payload),
      do: %__MODULE__{
        topic: topic,
        meta: meta,
        payload: payload
      }
  end

  defmodule Hope do
    use Ecto.Schema

    @moduledoc """
     Hope is the struct that identifies the initial state of a Farm.
    """
    alias Schema.Meta, as: Meta
    alias Schema.Details, as: Details

    @primary_key false
    embedded_schema do
      field(:topic, :string)
      embeds_one(:meta, Meta)
      embeds_one(:payload, Payload)
    end

    def new(id, details),
      do: %__MODULE__{
        topic: id,
        meta: meta,
        payload: payload
      }
  end

end
