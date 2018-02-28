defmodule Tasktracker.Work.Task do
  use Ecto.Schema
  import Ecto.Changeset
  import Tasktracker.Accounts
  alias Tasktracker.Work.Task
  alias Tasktracker.Accounts
  alias Tasktracker.Work
  alias Tasktracker.Work.TimeBlock


  schema "tasks" do
    field :complete, :boolean, default: false
    field :desc, :string
    field :time_spent, :integer
    field :title, :string
    # field :user_id, :id
    belongs_to :user, Tasktracker.Accounts.User
    belongs_to :manager, Tasktracker.Accounts.User
    has_many :timeblocks, TimeBlock, foreign_key: :id

    timestamps()

  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    minInHour = 60
    IO.inspect(task)
    IO.inspect(attrs)
    if attrs != Map.new do
      email = Map.get(attrs, "user_id")
      # if email == nil do
      #   uid = Map.get(task, "manager_id")
      # else
      IO.inspect(email)
      user = Accounts.get_user_by_email(email)
      uid = user.id
      manageid = Map.get(attrs, "manager_id")
      IO.inspect(manageid)
      if manageid == nil do
        manageid = user.manager_id
      end
      IO.inspect(Map.get(task, :id))
      timeblock_map = Work.time_block_map(Map.get(task, :id))
      IO.inspect(timeblock_map)
      time_spent = 0
      ts = Enum.map timeblock_map, fn t ->
            diff = DateTime.diff(Map.get(t, :end_time), Map.get(t, :start_time))
              # IO.inspect(diff)
            round(diff/60)
                # IO.inspect(time_spent)
            end
      IO.inspect(ts)
      time_spent = Enum.sum(ts)
      attrs = %{"complete" => Map.get(attrs, "complete"), "desc" => Map.get(attrs, "desc"),
      "time_spent" => time_spent, "title" => Map.get(attrs, "title"), "user_id" => uid, "manager_id" => manageid}
    end

    task
    |> cast(attrs, [:user_id, :manager_id, :title, :desc, :time_spent, :complete])
    |> validate_required([:user_id, :title, :desc, :time_spent, :complete])
    |> validate_number(:time_spent, greater_than: -1)
  end
end
