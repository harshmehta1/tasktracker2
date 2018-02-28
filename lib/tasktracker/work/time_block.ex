defmodule Tasktracker.Work.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Work.TimeBlock


  schema "timeblocks" do
    field :end_time, :utc_datetime
    field :start_time, :utc_datetime
    # field :task_id, :id
    belongs_to :task, Tasktracker.Work.Task

    timestamps()
  end

  @doc false
  def changeset(%TimeBlock{} = time_block, attrs) do
    time_block
    |> cast(attrs, [:start_time, :end_time, :task_id])
    |> validate_required([:start_time, :end_time])
  end
end
