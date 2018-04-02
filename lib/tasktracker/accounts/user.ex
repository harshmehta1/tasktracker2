defmodule Tasktracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Accounts.User
  alias Tasktracker.Accounts


  schema "users" do
    field :email, :string
    field :name, :string

    belongs_to :manager, User
    has_many :managee, User, foreign_key: :manager_id

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    if attrs != Map.new and user != nil do
      manage_email = Map.get(attrs, "manager_id")
      IO.inspect(manage_email)
      if manage_email != "None" and (not is_nil(manage_email) )  do
        manage_user = Accounts.get_user_by_email(manage_email)
        uid = Map.get(manage_user, :id)
      else
        uid = nil
      end
      attrs = %{"name" => Map.get(attrs, "name"), "email" => Map.get(attrs, "email"), "manager_id" => uid}
      IO.inspect(attrs)
    end

    user
    |> cast(attrs, [:email, :name, :manager_id])
    |> unique_constraint(:email)
    |> validate_required([:email, :name])
    |> validate_format(:email, ~r/@/)
  end
end
