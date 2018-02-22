# Tasktracker

Design Choices:
1. Description is of type text, as I think there should not be a limit on the description, since tasks can be assigned to other users, the description of tasks can be detailed and often long.
2. Another design decision I made was to have two input fields for hours and minutes for ease of use as well as limiting inputs to 15 minute increments.
3. Added unique constraint for emails as two users should not have the same email ID.
4. Once user has logged in, he can no longer see the Log In page until he logs out.
5. If a user is not logged in, he cannot check the task feed.
6. Only the user who the task is assigned to can edit/delete the task.
7. Users cannot edit/delete other users.
8. Once task is completed, it cannot be edited.
9. A logged in user has two choices to create new task, one a form on the top of the task feed and two through the new task button. I did this as someone who wants to create a single task quickly can use the task feeds form and if someone wants to create and work on multiple tasks, they can open it in new tabs.
10. Users have the option of seeing a general task feed (all tasks) or a custom one (my task feed), wherein they only have option to edit and delete tasks in their task feed (personal).
11. I have also given the option to edit profile where users can change their profile details.
12. Completed tasks on task feeds are color coded as green and cannot be edited.
13. When a user is deleted, all his tasks are transfered to the Admin who can choose who to reassign them to.
14. If a user deletes himself (from edit option), he gets logged out of the session.
15. The Admin has the root privileges of editing/deleting any user or task.
16. Admin can edit/delete users and tasks using "Edit Users" and "Edit Tasks" buttons respectively.
17. Admin can log in using email "admin@mehtaharsh.me"

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
