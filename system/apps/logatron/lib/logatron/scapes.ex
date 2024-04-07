defmodule Logatron.Scapes do
  @moduledoc """
  The Scapes context.
  """
  alias Logatron.Scapes.{Scape, Region, Farm, Animal}

  def list_dummy_scapes() do
    [
      %Scape{
        id: "1",
        name: "Europe",
        regions: [
          %Region{
            id: "1",
            name: "Region 1",
            description: "Description 1",
            latitude: 1.0,
            longitude: 1.0,
            farms: [
              %Farm{
                id: "1",
                name: "Farm 1",
                description: "Description 1",
                latitude: 1.0,
                longitude: 1.0,
                animals: [
                  %Animal{
                    id: "1",
                    name: "Animal 1",
                    gender: "male",
                    age: 1,
                    weight: 120,
                    energy: 100,
                    is_pregnant: false,
                    heath: 100,
                    health: 100,
                    position: %Logatron.Schema.Vector{
                      x: 1,
                      y: 1,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "2",
                    name: "Animal 2",
                    gender: "female",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 7,
                      y: 15,
                      z: 1
                    }
                  }
                ]
              },
              %Farm{
                id: "2",
                name: "Farm 2",
                description: "Description 2",
                latitude: 2.0,
                longitude: 2.0,
                animals: [
                  %Animal{
                    id: "3",
                    name: "Animal 3",
                    gender: "female",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 7,
                      y: 15,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "4",
                    name: "Animal 4",
                    gender: "female",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 7,
                      y: 15,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "14",
                    name: "Animal 14",
                    gender: "female",
                    age: 7,
                    weight: 109,
                    energy: 96,
                    is_pregnant: false,
                    heath: 78,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 36,
                      y: 19,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "15",
                    name: "Animal 15",
                    gender: "male",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 7,
                      y: 15,
                      z: 1
                    }
                  }

                ]
              }
            ]
          },
          %Region{
            id: "2",
            name: "Region 2",
            description: "Description 2",
            latitude: 2.0,
            longitude: 2.0,
            farms: [
              %Farm{
                id: "3",
                name: "Farm 3",
                description: "Description 3",
                latitude: 3.0,
                longitude: 3.0,
                animals: [
                  %Animal{
                    id: "26",
                    name: "Animal 26",
                    gender: "female",
                    age: 8,
                    weight: 90,
                    energy: 97,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 37,
                      y: 5,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "27",
                    name: "Animal 27",
                    gender: "female",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 7,
                      y: 15,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "28",
                    name: "Animal 28",
                    gender: "male",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: false,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 17,
                      y: 11,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "29",
                    name: "Animal 29",
                    gender: "female",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 7,
                      y: 15,
                      z: 1
                    }
                  }
                ]
              },
              %Farm{
                id: "4",
                name: "Farm 4",
                description: "Description 4",
                latitude: 4.0,
                longitude: 4.0,
                animals: [
                  %Animal{
                    id: "36",
                    name: "Animal 36",
                    gender: "female",
                    age: 8,
                    weight: 90,
                    energy: 97,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 37,
                      y: 5,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "37",
                    name: "Animal 37",
                    gender: "female",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: true,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 7,
                      y: 15,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "38",
                    name: "Animal 38",
                    gender: "male",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: false,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 17,
                      y: 11,
                      z: 1
                    }
                  },
                  %Animal{
                    id: "39",
                    name: "Animal 39",
                    gender: "male",
                    age: 3,
                    weight: 117,
                    energy: 98,
                    is_pregnant: false,
                    heath: 0,
                    health: 97,
                    position: %Logatron.Schema.Vector{
                      x: 43,
                      y: 19,
                      z: 1
                    }
                  }
                ]
              }
            ]
          }
        ]
      },
      %Scape{
        id: "2",
        name: "Scape 2",
        regions: [
          %Region{
            id: "3",
            name: "Region 3",
            description: "Description 3",
            latitude: 3.0,
            longitude: 3.0,
            farms: [
              %Farm{
                id: "5",
                name: "Farm 5",
                description: "Description 5",
                latitude: 5.0,
                longitude: 5.0
              },
              %Farm{
                id: "6",
                name: "Farm 6",
                description: "Description 6",
                latitude: 6.0,
                longitude: 6.0
              }
            ]
          },
          %Region{
            id: "4",
            name: "Region 4",
            description: "Description 4",
            latitude: 4.0,
            longitude: 4.0,
            farms: [
              %Farm{
                id: "7",
                name: "Farm 7",
                description: "Description 7",
                latitude: 7.0,
                longitude: 7.0
              },
              %Farm{
                id: "8",
                name: "Farm 8",
                description: "Description 8",
                latitude: 8.0,
                longitude: 8.0
              }
            ]
          }
        ]
      }
    ]
  end
end
