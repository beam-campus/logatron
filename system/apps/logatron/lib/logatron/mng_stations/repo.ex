defmodule Logatron.MngStations.Repo do
  alias Logatron.MngStations.Schema.StationNode
  alias Logatron.MngStations.Schema.Station

  def db() do
    [
      %Station{
        name: "Station 1",
        description: "This is station 1",
        user_email: "rl@discomco.pl",
        architecture: "kubernetes",
        station_nodes: [
          %StationNode{
            role: "master",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          },
          %StationNode{
            role: "worker",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          },
          %StationNode{
            role: "worker",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          },
          %StationNode{
            role: "worker",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          }
        ]
      },
      %Station{
        name: "Station 2",
        description: "This is station 2",
        user_email: "rl@discomco.pl",
        architecture: "standalone",
        station_nodes: [
          %StationNode{
            role: "master",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          }
        ]
      },
      %Station{
        name: "Station 3",
        description: "This is station 3",
        user_email: "pap@go.io",
        architecture: "standalone",
        station_nodes: [
          %StationNode{
            role: "master",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          }
        ]
      },
      %Station{
        name: "Station 4",
        description: "This is station 4",
        user_email: "rl@discomco.pl",
        architecture: "OTP",
        station_nodes: [
          %StationNode{
            role: "peer",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          },
          %StationNode{
            role: "peer",
            brand: "Raspberry",
            model: "Pi4",
            memory: 4,
            storage: 32,
            link_type: "ethernet",
            opsys: "linux"
          }
        ]
      }
    ]
  end
end
