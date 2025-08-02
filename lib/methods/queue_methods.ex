defmodule TamnoonTtt.Methods.QueueMethods do
  require Logger
  import Tamnoon.MethodManager

  defmethod :queue_handshake do
    sender = req["sender"]
    self_pid = inspect(self())

    # Only start a game if this method was published by another client
    if sender == nil || sender == self_pid do
      {}
    else
      other_player_name = req["name"]
      channel_name = "match#{sender}#{self_pid}"

      new_state =
        state
        |> Map.put(:other_player_name, other_player_name)
        |> Map.put(:channel_name, channel_name)

      Tamnoon.Methods.pub(
        %{
          "channel" => "queue",
          "action" => %{
            "method" => "start_game",
            "channel_name" => channel_name,
            "other_name" => state[:name],
            "sender" => self_pid
          }
        },
        new_state
      )

      {%{other_player_name: other_player_name, channel_name: channel_name}}
    end
  end

  defmethod :start_game do
    # TBD

    Tamnoon.Methods.unsub(%{"channel" => "queue"}, state)

    Logger.info("Started game for #{state[:name]} in channel #{req["channel_name"]}")

    {}
  end
end
