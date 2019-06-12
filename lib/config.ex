defmodule Footprint.Client do
  @moduledoc false

  def repo, do: Application.get_env(:footprint, :repo, Repo)
end
