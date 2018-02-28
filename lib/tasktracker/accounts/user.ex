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
    if attrs != Map.new do
      managees = Map.get(attrs, "managee_ids")

      if managees != [] and (not is_nil(managees)) do
        Enum.map managees, fn m ->
          managee_user = Accounts.get_user(m)
          main_id = user.email
          params = %{"name" => Map.get(managee_user, :name), "email" => Map.get(managee_user, :email), "manager_id" => main_id, "managee_ids" => nil}
          Accounts.update_user(managee_user, params)
          managee_user = Accounts.get_user(m)
         end
      end

      manage_email = Map.get(attrs, "manager_id")
      if manage_email != "None" and (not is_nil(manage_email) )  do
        manage_user = Accounts.get_user_by_email(manage_email)
        uid = manage_user.id
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
