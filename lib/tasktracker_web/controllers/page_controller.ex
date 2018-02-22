defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    # cu = Map.get(Map.get(conn, :assigns), :current_user)
    uid = get_session(conn, :user_id)
    IO.inspect(uid)
     if uid == nil do
      render conn, "index.html"
    else
      feed(conn, %{})
    end
  end

  def feed(conn, _params) do

    uid = get_session(conn, :user_id)
    if uid == nil do
      index(conn, _params)
    else
      # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
      users = Tasktracker.Accounts.list_users()
              |> Enum.map(&[&1.email])
              |> Enum.concat
      tasks = Tasktracker.Work.list_user_tasks(uid)
      changeset = Tasktracker.Work.change_task(%Tasktracker.Work.Task{})
      render conn, "taskfeed.html", tasks: tasks, users: users, changeset: changeset
    end
  end

  def alltasks(conn, _params) do
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.list_users()
            |> Enum.map(&[&1.email])
            |> Enum.concat
    tasks = Tasktracker.Work.list_tasks()
    changeset = Tasktracker.Work.change_task(%Tasktracker.Work.Task{})
    render conn, "alltasks.html", tasks: tasks, users: users, changeset: changeset
  end

end
