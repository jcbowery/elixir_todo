defmodule Todo.TaskTest do
  use ExUnit.Case, async: true
  doctest Todo.Task

  alias Todo.Task

  @task_incomplete %Task{id: 1, title: "my task", completed: false}

  @task_complete %Task{id: 1, title: "my task", completed: true}

  describe "new" do
    test "Task.new/3 returns %Task{}" do
      %Task{} = task = Task.new(1, "my task", true)
      assert task.id == 1
      assert task.title == "my task"
      assert task.completed == true
    end

    test "Task.new/2 returns %Task{}" do
      %Task{} = task = Task.new(1, "my task")
      assert task.id == 1
      assert task.title == "my task"
      assert task.completed == false
    end
  end

  describe "complete" do
    test "Task.complete/2 returns %Task{} with completed true" do
      %Task{} = task = Task.complete(@task_incomplete)
      assert task.completed == true
    end
  end

  describe "incomplete" do
    test "Task.incomplete/2 returns %Task{} with completed false" do
      %Task{} = task = Task.incomplete(@task_complete)
      assert task.completed == false
    end
  end
end
