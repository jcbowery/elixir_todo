defmodule Todo.Task do
  @moduledoc """
  Represents a task in a Todo application.

  Provides functions for creating and updating task state.
  """

  alias __MODULE__

  @enforce_keys [:id, :title]
  defstruct [:id, title: nil, completed: false]

  @type t :: %__MODULE__{
          id: integer(),
          title: String.t(),
          completed: boolean()
        }

  @doc """
  Creates a new task with the given `id` (integer), `title`, and optional `completed` status (defaults to `false`).

  ## Examples

      iex> Todo.Task.new(1, "Buy milk")
      %Todo.Task{id: 1, title: "Buy milk", completed: false}

      iex> Todo.Task.new(2, "Call Alice", true)
      %Todo.Task{id: 2, title: "Call Alice", completed: true}
  """
  @spec new(integer(), String.t(), boolean()) :: Task.t()
  def new(id, title, completed \\ false), do: %Task{id: id, title: title, completed: completed}

  @doc """
  Marks the given task as completed.

  ## Examples

      iex> task = Todo.Task.new(1, "Do laundry")
      iex> Todo.Task.complete(task)
      %Todo.Task{id: 1, title: "Do laundry", completed: true}
  """
  @spec complete(Task.t()) :: Task.t()
  def complete(%Task{} = task), do: %Task{task | completed: true}

  @doc """
  Marks the given task as not completed.

  ## Examples

      iex> task = Todo.Task.new(1, "Do laundry", true)
      iex> Todo.Task.incomplete(task)
      %Todo.Task{id: 1, title: "Do laundry", completed: false}
  """
  @spec incomplete(Task.t()) :: Task.t()
  def incomplete(%Task{} = task), do: %Task{task | completed: false}
end
