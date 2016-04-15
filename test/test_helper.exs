ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Tunedrop.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Tunedrop.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Tunedrop.Repo)

