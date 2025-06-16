defmodule Todo.TaskList do
  @moduledoc """
  Manages a collection of Todo tasks.

  Provides functions to add, update, and remove tasks in a task list.
  """

  alias __MODULE__
  alias Todo.Task

  defstruct current_id: 0, tasks: %{}

  @type t :: %__MODULE__{
          current_id: integer(),
          tasks: %{integer() => Task.t()}
        }

  @doc """
  Creates a new empty task list.

  ## Examples

      iex> Todo.TaskList.new()
      %Todo.TaskList{current_id: 0, tasks: %{}}
  """
  @spec new() :: t()
  def new(), do: %TaskList{}

  @doc """
  Adds a new task to the list with the given title and optional completion status.

  Returns the updated task list with the new task included.

  ## Examples

      iex> list = Todo.TaskList.new()
      iex> updated_list = Todo.TaskList.add_task(list, "Read a book")
      iex> Map.has_key?(updated_list.tasks, 1)
      true
  """
  @spec add_task(t(), String.t(), boolean()) :: t()
  def add_task(%TaskList{} = task_list, title, completed \\ false) do
    id = task_list.current_id + 1
    task = Task.new(id, title, completed)
    tasks = Map.put(task_list.tasks, id, task)
    %TaskList{current_id: id, tasks: tasks}
  end

  @doc """
  Marks a task as complete by ID.

  Returns `{:ok, updated_list}` if the task exists, or `{:error, :task_not_found}` otherwise.

  ## Examples

      iex> list = Todo.TaskList.new() |> Todo.TaskList.add_task("Clean room")
      iex> {:ok, updated_list} = Todo.TaskList.mark_task_complete(list, 1)
      iex> updated_list.tasks[1].completed
      true

      iex> list = Todo.TaskList.new() |> Todo.TaskList.add_task("Clean room")
      iex> {:error, :task_not_found} = Todo.TaskList.mark_task_complete(list, 2)
  """
  @spec mark_task_complete(t(), integer()) :: {:ok, t()} | {:error, :task_not_found}
  def mark_task_complete(task_list, id),
    do: update_task_status(task_list, id, &Task.complete/1)

  @doc """
  Marks a task as incomplete by ID.

  Returns `{:ok, updated_list}` if the task exists, or `{:error, :task_not_found}` otherwise.

  ## Examples

      iex> list = Todo.TaskList.new() |> Todo.TaskList.add_task("Walk dog", true)
      iex> {:ok, updated_list} = Todo.TaskList.mark_task_incomplete(list, 1)
      iex> updated_list.tasks[1].completed
      false

      iex> list = Todo.TaskList.new() |> Todo.TaskList.add_task("Walk dog", true)
      iex> {:error, :task_not_found} = Todo.TaskList.mark_task_incomplete(list, 2)
  """
  @spec mark_task_incomplete(t(), integer()) :: {:ok, t()} | {:error, :task_not_found}
  def mark_task_incomplete(task_list, id),
    do: update_task_status(task_list, id, &Task.incomplete/1)

  @doc """
  Removes a task from the list by ID.

  Returns the updated task list, regardless of whether the task existed.

  ## Examples

      iex> list = Todo.TaskList.new() |> Todo.TaskList.add_task("Write report")
      iex> updated_list = Todo.TaskList.remove_task(list, 1)
      iex> Map.has_key?(updated_list.tasks, 1)
      false
  """
  @spec remove_task(t(), integer()) :: t()
  def remove_task(%TaskList{} = task_list, id) do
    tasks = Map.delete(task_list.tasks, id)
    %TaskList{task_list | tasks: tasks}
  end

  # Private helper function
  @spec update_task_status(t(), integer(), (Task.t() -> Task.t())) ::
          {:ok, t()} | {:error, :task_not_found}
  defp update_task_status(%TaskList{} = task_list, id, status_fun) do
    case Map.fetch(task_list.tasks, id) do
      {:ok, task} ->
        updated_task = status_fun.(task)
        tasks = Map.put(task_list.tasks, id, updated_task)
        {:ok, %TaskList{task_list | tasks: tasks}}

      :error ->
        {:error, :task_not_found}
    end
  end
end
