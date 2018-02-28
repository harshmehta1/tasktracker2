defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Work
  alias Tasktracker.Work.Task

  def index(conn, _params) do
    tasks = Work.list_tasks()
    task = []
    IO.inspect(tasks)
    render(conn, "index.html", tasks: tasks, task: task)
  end

  def taskreport(conn, _params) do
    current_user = conn.assigns[:current_user]
    managees = Tasktracker.Accounts.get_all_underlings(current_user.id)
    # IO.inspect(managees)
    tasks = Enum.map managees, fn m ->
                mid = Integer.to_string(Map.get(m, :id))
      # IO.inspect(mid)
      # temp =
                Work.list_user_tasks(mid)
      # IO.inspect(temp)
      # tasks ++ [temp]
                end
    tasks = Enum.concat(tasks)
    # IO.inspect(tasks)
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    current_user = conn.assigns[:current_user]
    timeblocks = nil
    task = nil
    uid = Integer.to_string(current_user.id)
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.get_all_underlings(uid)
            |> Enum.map(&[&1.email])
            |> Enum.concat

    if users == [] do
      conn
      |> put_flash(:error, "No permission to add new task")
      |> redirect(to: page_path(conn, :feed))
    end
    IO.inspect(users)
    changeset = Work.change_task(%Task{})
    render(conn, "new.html", users: users, task: task, timeblocks: timeblocks, changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    current_user = conn.assigns[:current_user]
    timeblocks = nil
    task = nil
    uid = Integer.to_string(current_user.id)
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.get_all_underlings(uid)
            |> Enum.map(&[&1.email])
            |> Enum.concat

    case Work.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", users: users, task: task, timeblocks: timeblocks, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do

    current_user = get_session(conn,:user_id)
    timeblocks = Tasktracker.Work.time_block_map(id)
    timeblocks = Enum.map timeblocks, fn t ->
                  %{:start_time => DateTime.to_naive(Map.get(t, :start_time)), :end_time => DateTime.to_naive(Map.get(t, :end_time)), :id => Map.get(t, :id)}
                end

    admin = Tasktracker.Accounts.get_user!(current_user)
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.get_all_underlings(Integer.to_string(current_user))
            |> Enum.map(&[&1.email])
            |> Enum.concat
    task = Work.get_task!(id)
    IO.inspect(task)
    task_user = Map.get(Map.get(task, :user), :id)

    if users == [] and task_user != current_user do
      conn
      |> put_flash(:error, "No permission to edit task")
      |> redirect(to: page_path(conn, :feed))
    end


    # if task_user == current_user or admin.email == "admin@mehtaharsh.me" do
      complete = Map.get(task, :complete)
      if complete do
        conn
        |> put_flash(:error, "Cannot edit completed tasks")
        |> redirect(to: page_path(conn, :feed))
      else
        email = Map.get(Map.get(task, :user), :email)
        ts = Map.get(task, :time_spent)
        hh = round(ts/60);
        mm = ts - hh * 60;

        task = Map.replace!(task, :user_id, email)
              |> Map.put(:h_time_spent, hh)
              |> Map.put(:m_time_spent, mm)

        changeset = Work.change_task(task)
        render(conn, "edit.html", users: users, timeblocks: timeblocks, task: task, changeset: changeset)
      end
    # else
    #   conn
    #   |> put_flash(:error, "Cannot edit another users tasks")
    #   |> redirect(to: page_path(conn, :feed))
    # end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do

    current_user = conn.assigns[:current_user]
    task = Work.get_task!(id)
    timeblocks = Tasktracker.Work.time_block_map(id)
    timeblocks = Enum.map timeblocks, fn t ->
                  %{:start_time => DateTime.to_naive(Map.get(t, :start_time)), :end_time => DateTime.to_naive(Map.get(t, :end_time)), :id => Map.get(t, :id)}
                end
    # Attribution: https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    users = Tasktracker.Accounts.get_all_underlings(current_user.id)
            |> Enum.map(&[&1.email])
            |> Enum.concat
    case Work.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, users: users, timeblocks: timeblocks, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Work.get_task!(id)
    {:ok, _task} = Work.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end
