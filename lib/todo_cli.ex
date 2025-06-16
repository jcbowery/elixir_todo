defmodule Todo do
  @moduledoc """
  Documentation for `TodoCli`.
  """

  alias Todo.TaskList

  @prompt """
    == TODO LIST ==
  Available Commands:
  - add <task_title>        # Add a new task
  - remove <task_id>        # Remove a task by ID
  - complete <task_id>      # Mark a task as complete
  - incomplete <task_id>    # Mark a task as incomplete
  - list                    # Display all tasks
  - quit                    # Exit the application

  >\n
  """

  defp quit() do
    clear_console()
    IO.puts("Goodbye!")
    :quit
  end

  defp prompt_and_response() do
    response = IO.gets("Pick an option:\n")
    response |> String.trim() |> String.downcase()
  end

  defp split_command_and_argument(response) do
    [command | argument] =
      response
      |> String.split(" ", parts: 2)

    argument = List.to_string(argument)
    {command, argument}
  end

  defp add(%TaskList{} = tl, argument) do
    clear_console()
    tl = TaskList.add_task(tl, argument)
    IO.puts("OK\n")
    IO.gets("press any key to continue")
    loop(tl)
  end

  defp remove(%TaskList{} = tl, argument) do
    clear_console()
    tl = TaskList.remove_task(tl, String.to_integer(argument))
    IO.puts("OK\n")
    IO.gets("press any key to continue")
    loop(tl)
  end

  defp convert_argument_to_int(argument) do
    try do
      String.to_integer(argument)
    rescue
      ArgumentError ->
        -1
    end
  end

  defp update_completion_status(%TaskList{} = tl, argument, action_fun) do
    clear_console()
    argument = convert_argument_to_int(argument)

    with {:ok, tl} <- action_fun.(tl, argument) do
      IO.puts("OK\n")
      IO.gets("press any key to continue")
      loop(tl)
    else
      {:error, :task_not_found} ->
        IO.puts("\nTask was not found")
        loop(tl)

      _ ->
        IO.puts("Fatal Error")
        quit()
    end
  end

  defp complete(tl, argument),
    do: update_completion_status(tl, argument, &TaskList.mark_task_complete/2)

  defp incomplete(tl, argument),
    do: update_completion_status(tl, argument, &TaskList.mark_task_incomplete/2)

  defp list(%TaskList{} = tl) do
    clear_console()
    Enum.each(tl.tasks, fn {_, task} ->
      IO.puts("#{task.id} - #{task.title} - completed: #{task.completed}")
    end)

    IO.puts("\n")
    IO.gets("press any key to continue")
    loop(tl)
  end

  defp clear_console do
    IO.write(IO.ANSI.clear())
    IO.write(IO.ANSI.home())
  end

  def loop(tl \\ Todo.TaskList.new()) do
    clear_console()
    IO.puts(@prompt)

    response = prompt_and_response()

    {command, argument} = split_command_and_argument(response)

    case command do
      "add" ->
        add(tl, argument)

      "remove" ->
        remove(tl, argument)

      "complete" ->
        complete(tl, argument)

      "incomplete" ->
        incomplete(tl, argument)

      "list" ->
        list(tl)

      "quit" ->
        quit()

      _ ->
        IO.puts("\n INVALID OPTION. TRY AGAIN.\n")
        loop(tl)
    end
  end

  def main(_args \\ []) do
    loop()
  end
end
