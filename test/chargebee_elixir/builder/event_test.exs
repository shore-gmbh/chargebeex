defmodule Chargebeex.Builder.EventTest do
  use ExUnit.Case, async: true

  alias Chargebeex.Builder
  alias Chargebeex.Customer
  alias Chargebeex.Fixtures.Event, as: EventFixture
  alias Chargebeex.Event

  describe "build/1" do
    test "should build a full event" do
      builded =
        EventFixture.retrieve()
        |> Jason.decode!()
        |> Builder.build("event", with_extra: true)

      assert %{"event" => %Event{}} = builded
    end

    test "should build a simple event" do
      builded =
        EventFixture.retrieve()
        |> Jason.decode!()
        |> Builder.build("event")

      assert %Event{} = builded

      builded =
        EventFixture.retrieve()
        |> Jason.decode!()
        |> Builder.build("event", with_extra: false)

      assert %Event{} = builded
    end

    test "should build a list of full event" do
      builded =
        EventFixture.list()
        |> Jason.decode!()
        |> Builder.build("event", with_extra: true)

      assert {[
                %{"event" => %Event{}},
                %{"event" => %Event{}}
              ], %{"next_offset" => _}} = builded
    end

    test "should build a list of simple event" do
      builded =
        EventFixture.list()
        |> Jason.decode!()
        |> Builder.build("event", with_extra: false)

      assert {[
                %Event{},
                %Event{}
              ], %{"next_offset" => _}} = builded

      builded =
        EventFixture.list()
        |> Jason.decode!()
        |> Builder.build("event")

      assert {[
                %Event{},
                %Event{}
              ], %{"next_offset" => _}} = builded
    end

    test "should have event params" do
      event =
        EventFixture.retrieve()
        |> Jason.decode!()
        |> Builder.build("event", with_extra: false)

      params = EventFixture.event_params() |> Jason.decode!()

      assert event.api_version == Map.get(params, "api_version")
      assert event.event_type == Map.get(params, "event_type")
      assert event.id == Map.get(params, "id")
      assert event.object == Map.get(params, "object")
      assert event.occurred_at == Map.get(params, "occurred_at")
      assert event.source == Map.get(params, "source")
      assert event.user == Map.get(params, "user")
      assert event.webhook_status == Map.get(params, "webhook_status")

      assert %Customer{} = event.content["customer"]
    end
  end
end
