defmodule ReleaseRightPoc.InitializeReleaseRightPoc.ToLog do
  use Commanded.Event.Handler,
    application: ReleaseRightPoc.CommandedApp,
    name: "RRPocInitialized.ToLog.v1",
    start_from: :origin

    alias ReleaseRightPoc.InitializeReleaseRightPoc.Evt,
      as: ReleaseRightPocInitialized

      require Logger



    def handle(%ReleaseRightPocInitialized{} = event, metadata) do
      Logger.alert("

      RRPocInitialized.ToLog.v1:
      EVENT:
      \t #{inspect(event)}
      METADATA:
      \t #{inspect(metadata)}

      ")
      :ok
    end



end
