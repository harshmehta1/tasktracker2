# Tasktracker

Design Choices for TaskTracker Pt. 2:
1.  While registering, there is an option to select manager/managees, so users can directly add who their manager/managees are without any additional effort.
2.  My aim was to simplify the process of assigning managers and getting managees assigned. My view is that the system will be used in a company environment and not prone to misuse.
3.  This option to add manager/managees stays while editing a user, in case there is a change of role for the user in the future.
4.  Managers can click on "View Task Report" to view the task report of all their underlings.
5.  For timeblocks feature, I am using ajax in jquery to add/update timeblocks.
6.  To add a timeblock, user can click on edit under task and go to the edit task page, where they have two options to add timeblocks, automatically - using start/stop button and manually - using date time fields.
7.  User can add any number of manual timeblocks.
8.  User can click on "Add Timeblock" button to add a manual time block where user can enter a start datetime and end datetime.
9.  These manual timeblocks will updated on form submit.
10. The Start Working button does not directly send data to json, it instead stores the datetime value of when it was clicked using javascript and only stores the data to database when "Stop Working" button is clicked.
11. Thus, the edit task page must be open to track time automatically.
12. Furthermore, I have added validations so that end datetime can never be earlier than start datettime.
13. Only user that the task is assigned to can add/edit/delete timeblocks.
14. I have preserved the time_spent feature for task report feature, where I calculate the total time spent on a task using timeblocks.
15. If a user is deleted, its tasks get assigned to the manager who can reassign them. If the user does not have a manager, it goes to admin who can reassign the task.
16. Only a manager can see the "view task report" button.
17. User cannot reassign a task, only the manager of the task can.
18. Users can only choose to manage users who do not have a manager.

Previous Design Choices for Task Tracker pt. 1:
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
