defmodule TamnoonTtt.Methods.GameMethods do
  require Logger
  import Tamnoon.MethodManager

  defmethod :start_turn do
    Logger.debug("turn started for #{req["player"]}")
    {}
  end
end
