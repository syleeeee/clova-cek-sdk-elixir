defmodule Clova do
  @moduledoc """
  A behaviour for Clova extentions.

  An implementation of this behaviour should be specified as the argument to the `Clova.Dispatcher` plug:

  ```
  plug Clova.Dispatcher, dispatch_to: MyExtension
  ```

  Each callback is called with a `Clova.Request` and `Clova.Response` struct. Helpers exist on those
  modules to extract data from the request and add data to the response. The callbacks should return
  the completed response struct, which will be added to the `Plug.Conn` struct by `Clova.Dispatcher`.
  """

  alias Clova.{Request, Response}

  @doc """
  Called when a `LaunchRequest` is received.

  The `response` parameter is an empty response which can be used with the functions
  in `Clova.Response` in order to produce a completed response to return.
  """
  @callback handle_launch(
              request :: Request.t(),
              response :: Response.t()
            ) :: Response.t()

  @doc """
  Called when an `IntentRequest` is received.

  The name of the intent is extracted and passed as the `name` argument,
  to allow for easier pattern matching. `Clova.Request.get_slot/2` can be used to retrieve
  the slot data for an intent.

  The `response` parameter is an empty response which can be used with the functions
  in `Clova.Response` in order to produce a completed response to return.
  """
  @callback handle_intent(
              name :: String.t(),
              request :: Request.t(),
              response :: Response.t()
            ) :: Response.t()

  @doc """
  Called when a `SessionEndedRequest` is received.

  The `response` parameter is an empty response which can be used with the functions
  in `Clova.Response` in order to produce a completed response to return. At the time of writing
  any response to a `SessionEndedRequest` is ignored by the server.
  """
  @callback handle_session_ended(
              request :: Request.t(),
              response :: Response.t()
            ) :: Response.t()

  defmacro __using__(_) do
    quote do
      @behaviour Clova
      import Clova.{Request, Response}

      def handle_launch(_request, response), do: response
      def handle_intent(_name, _request, response), do: response
      def handle_session_ended(_request, response), do: response
      defoverridable Clova
    end
  end
end
