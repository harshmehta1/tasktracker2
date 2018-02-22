defmodule Tasktracker.Work.Task do
  use Ecto.Schema
  import Ecto.Changeset
  import Tasktracker.Accounts
  alias Tasktracker.Work.Task
  alias Tasktracker.Accounts



  schema "tasks" do
    field :complete, :boolean, default: false
    field :desc, :string
    field :time_spent, :integer
    field :title, :string
    # field :user_id, :id
    belongs_to :user, Tasktracker.Accounts.User

    timestamps()

  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    minInHour = 60
    IO.inspect(attrs)
    if attrs != Map.new do
      email = Map.get(attrs, "user_id")
      IO.inspect(email)
      user = Accounts.get_user_by_email(email)
      uid = user.id
      IO.inspect(uid)
      hours = Map.get(attrs, "h_time_spent")
      if hours == "" do
        hh = 0
      else
        hh = String.to_integer(Map.get(attrs, "h_time_spent"))
      end
      mm = String.to_integer(Map.get(attrs, "m_time_spent"))
      time_spent = hh * minInHour + mm
      IO.inspect(time_spent)
      attrs = %{"complete" => Map.get(attrs, "complete"), "desc" => Map.get(attrs, "desc"),
      "time_spent" => time_spent, "title" => Map.get(attrs, "title"), "user_id" => uid}
    end
    task
    |> cast(attrs, [:user_id, :title, :desc, :time_spent, :complete])
    |> validate_required([:user_id, :title, :desc, :time_spent, :complete])
  end
end
