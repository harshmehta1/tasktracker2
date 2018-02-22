defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    current_user = get_session(conn, :user_id)
    IO.inspect(current_user)
    admin = Accounts.get_user!(current_user)
    us_id = String.to_integer(id)
    user = Accounts.get_user!(id)
    if us_id == current_user or admin.email == "admin@mehtaharsh.me" do
      if user.email == "admin@mehtaharsh.me" do
        conn
        |> put_flash(:error, "Cannot Edit Admin!")
        |> redirect(to: page_path(conn, :index))
      else
        changeset = Accounts.change_user(user)
        render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Not allowed to edit other users")
      |> redirect(to: page_path(conn, :feed))
  end
end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    adUser = Accounts.get_user_by_email("admin@mehtaharsh.me")
    tasks = Tasktracker.Work.list_user_tasks(id)

    Enum.map(tasks, fn task ->
        ts = Map.get(task, :time_spent)
        hh = round(ts/60)
        mm = ts - (hh * 60)
        hh = Integer.to_string(hh)
        mm = Integer.to_string(mm)
        attrs = %{"complete" => Map.get(task, :complete),
                  "desc" => Map.get(task, :desc), "h_time_spent" => hh,
                  "m_time_spent" => mm, "title" => Map.get(task,:title),
                  "user_id" => "admin@mehtaharsh.me"}

        og_task = Tasktracker.Work.get_task!(Integer.to_string(Map.get(task, :id)))
        task = Map.replace!(task, :user, adUser)
        IO.inspect(task)
        Tasktracker.Work.update_task(og_task, attrs)
    end)
    {:ok, _user} = Accounts.delete_user(user)
    curr_user = get_session(conn, :user_id)
    u_id = String.to_integer(id)
    if curr_user == u_id do
      TasktrackerWeb.SessionController.delete(conn, %{})
    end

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
