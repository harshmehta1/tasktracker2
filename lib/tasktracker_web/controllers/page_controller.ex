defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    # cu = Map.get(Map.get(conn, :assigns), :current_user)
    uid = conn.assigns[:current_user]
    IO.inspect(uid)
     if uid == nil do
      render conn, "index.html"
    else
      conn
      |> redirect(to: page_path(conn, :feed))
    end
  end

  def feed(conn, _params) do

    current_user = conn.assigns[:current_user]
    if current_user.id == nil do
      index(conn, _params)
    else
      timeblocks = nil
      task = nil
      # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
      users = Tasktracker.Accounts.get_all_underlings(current_user.id)
      tasks = Enum.map users, fn u ->
              Tasktracker.Work.list_user_tasks(Map.get(u, :id)) end
      temp = Tasktracker.Work.list_user_tasks(current_user.id)
      tasks = [temp] ++ tasks        
      tasks = Enum.concat(tasks)
      users = users
              |> Enum.map(&[&1.email])
              |> Enum.concat
      changeset = Tasktracker.Work.change_task(%Tasktracker.Work.Task{})
      render conn, "taskfeed.html", tasks: tasks, users: users, task: task, timeblocks: timeblocks, changeset: changeset
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
