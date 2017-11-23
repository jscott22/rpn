defmodule Rpn do
  def start do
    {:ok, spawn(__MODULE__, :loop, [[]])}
  end

  def loop(stack) do
    receive do
      {pid, :peek} ->
        send(pid, stack)
        loop(stack)
      {pid, {:push, :+}} ->
        Enum.sum(stack)
        |> loop()
      {pid, {:push, val}} ->
        loop([val | stack])
    end
  end

  def peek(pid) do
    send(pid, {self(), :peek})
    receive do
      stack ->
        stack
    end
  end

  def push(pid, val) do
    send(pid, {self(), {:push, val}})
  end
end
