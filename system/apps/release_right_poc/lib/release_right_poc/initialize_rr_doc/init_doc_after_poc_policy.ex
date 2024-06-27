defmodule ReleaseRightPoc.InitializeRrDoc.InitDocAfterPocPolicy do

  use Commanded.Event.Handler,
    application: ReleaseRightPoc.CommandedApp,
    name: "RRPocInitialized.InitDocAfterPocPolicy.v1",
    start_from: :origin

    alias ReleaseRightPoc.InitializeReleaseRightPoc.Evt,
      as: ReleaseRightPocInitialized

      alias ReleaseRightPoc.InitializeRRDoc.Cmd,
        as: InitializeRRDoc

      alias ReleaseRightPoc.Router,
        as: Router

      require Logger



    def handle(%ReleaseRightPocInitialized{} = event, _metadata) do

      Logger.alert("Initializing RR Doc after POC Policy for #{inspect(event)}")
      
      initializeDoc = %InitializeRRDoc{
        root_id: event.root_id,
        terminal_id: event.terminal_id,
        container_id: event.container_id
      }

      Router.dispatch(initializeDoc)

      :ok
    end




end
