ExEvercam
=========

##Elixir Client Library to the Evercam API

###Getting started
In your mix.exs file, add the following to your app's dependencies:

```elixir
{:exevercam, git: "https://github.com/markmeeus/ExEvercam.git"}
```

Then run
````
mix deps.update
```

###Example Usage

```elixir
config = %{
      credentials: %{api_id: "<YOUR API ID>", api_key: "<YOUR API KEY>"}
    }


{:ok, cameras} = config |> ExEvercam.API.Camera.list
{:ok, camera} = config |> ExEvercam.API.Camera.get("camera-id")
{:ok, snapshot} = config |> ExEvercam.API.Snapshot.get_at(@test_camera_id, 1400606432, false, 60)
```


