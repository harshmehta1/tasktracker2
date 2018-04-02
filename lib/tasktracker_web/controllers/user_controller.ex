defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.list_users()
            |> Enum.map(&[&1.email])
            |> Enum.concat
    users = List.delete(users, "admin@mehtaharsh.me")
    manager = nil
    users = ["None"] ++ users
    managee = Tasktracker.Accounts.get_managee()
    underlings = nil
    ul_map = nil

    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", users: users, managee: managee, manager: manager, ulmap: ul_map, underlings: underlings, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    IO.inspect("create block")
    IO.inspect(user_params)
    managees = Map.get(user_params, "managee_ids")
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.list_users()
            |> Enum.map(&[&1.email])
            |> Enum.concat
    users = List.delete(users, "admin@mehtaharsh.me")
    users = ["None"] ++ users
    manager = nil
    ul_map = nil
    managee = Tasktracker.Accounts.get_managee()
    current_user = conn.assigns[:current_user]
    underlings = nil
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        if managees != [] and (not is_nil(managees)) do
          Enum.map managees, fn m ->
            managee_user = Accounts.get_user(m)
            main_id = Map.get(user_params, "email")
            IO.inspect(main_id)
            params = %{"name" => Map.get(managee_user, :name), "email" => Map.get(managee_user, :email), "manager_id" => main_id, "managee_ids" => nil}
            Accounts.update_user(managee_user, params)
           end
        end
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", users: users, underlings: underlings, managee: managee, manager: manager, ulmap: ul_map, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    mid = Map.get(user, :manager_id)
    if mid != nil do
      manager = Accounts.get_user(mid)
    else
      manager = nil
    end
    underlings = Accounts.get_all_underlings(id)

    render(conn, "show.html", user: user, manager: manager, underlings: underlings)
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    if current_user != nil do
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.list_users()
            |> Enum.map(&[&1.email])
            |> Enum.concat
    users = List.delete(users, "admin@mehtaharsh.me")
    users = ["None"] ++ users
    managee = Tasktracker.Accounts.get_managee()
    underlings = Tasktracker.Accounts.get_all_underlings(id)
                |> Enum.map(&[&1.email])
                |> Enum.concat
    if current_user.manager_id != nil do
      manager = Tasktracker.Accounts.get_user(current_user.manager_id)
    else
      manager = nil
    end
    IO.inspect(current_user)
    ul_map = Tasktracker.Accounts.get_underlings_map(id)

    admin = Accounts.get_user!(Integer.to_string(current_user.id))
    us_id = String.to_integer(id)
    user = Accounts.get_user!(id)
    if us_id == current_user.id or admin.email == "admin@mehtaharsh.me" do
      if user.email == "admin@mehtaharsh.me" do
        conn
        |> put_flash(:error, "Cannot Edit Admin!")
        |> redirect(to: page_path(conn, :index))
      else
        changeset = Accounts.change_user(user)
        render(conn, "edit.html", user: user, users: users, underlings: underlings, ulmap: ul_map, manager: manager, managee: managee, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Not allowed to edit other users")
      |> redirect(to: page_path(conn, :feed))
  end
  else
    conn
    |> put_flash(:error, "Cannot edit without login")
    |> redirect(to: page_path(conn, :index))
  end
end


  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    users = Tasktracker.Accounts.list_users()
            |> Enum.map(&[&1.email])
            |> Enum.concat
    users = List.delete(users, "admin@mehtaharsh.me")
    users = ["None"] ++ users
    managees = Map.get(user_params, "managee_ids")
    if user.manager_id != nil do
      manager = Tasktracker.Accounts.get_user(user.manager_id)
    else
      manager = nil
    end
    underlings = Tasktracker.Accounts.get_all_underlings(id)
                |> Enum.map(&[&1.email])
                |> Enum.concat

    ul_map = Tasktracker.Accounts.get_underlings_map(id)
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        if managees != [] and (not is_nil(managees)) do
          Enum.map managees, fn m ->
            managee_user = Accounts.get_user(m)
            main_id = Map.get(user_params, "email")
            IO.inspect(main_id)
            params = %{"name" => Map.get(managee_user, :name), "email" => Map.get(managee_user, :email), "manager_id" => main_id, "managee_ids" => nil}
            Accounts.update_user(managee_user, params)
           end
        end
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, users: users, underlings: underlings, ulmap: ul_map, manager: manager, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)


    if user.manager_id != nil do
      adUser = Accounts.get_user(Map.get(user, :manager_id))
    else
      adUser = Accounts.get_user_by_email("admin@mehtaharsh.me")
    end

    rep_email = Map.get(adUser, :email)
    mid1 = Map.get(adUser, :id)
    IO.inspect(mid1)

    tasks = Tasktracker.Work.list_user_tasks(id)

    if user.email == "admin@mehtaharsh.me" do
      conn
      |> put_flash(:error, "Cannot delete admin")
      |> redirect(to: user_path(conn, :index))
    else
      Enum.map(tasks, fn task ->
          attrs = %{"complete" => Map.get(task, :complete),
                    "desc" => Map.get(task, :desc),
                    "title" => Map.get(task,:title),
                    "user_id" => rep_email,
                    "manager_id" => mid1}

          og_task = Tasktracker.Work.get_task!(Integer.to_string(Map.get(task, :id)))
          task = Map.replace!(task, :user, adUser)

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
end
