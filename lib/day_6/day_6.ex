defmodule Advent.Day6 do
  @moduledoc """
  Day 6
  """

  def get_lines_from_file(filename) do
    {:ok, binary} = File.read("lib/day_6/#{filename}")

    binary
    |> String.split("\n")
  end

  def process_line(line) do
    String.split(line, ")")
  end

  def get_links(filename) do
    filename
      |> get_lines_from_file()
      |> Enum.map(&process_line/1)
  end

  def validate_map(filename) do
    links = get_links(filename)


    nodes =
      links
      |> List.flatten(links)
      |> Enum.uniq

    parent_count(nodes, links)
  end

  def parent_count(children, links) when is_list(children) do
    children
    |> Enum.reduce(0, fn c, acc -> acc + parent_count(c, links) end)
  end

  def parent_count(child, links) when not is_list(child) do
    parent =
      Enum.filter(links, fn [_p,c] -> c == child end)
      |> Enum.map(fn [p, _c] -> p end)

    case parent do
      [] -> 0
      _ -> 1 + parent_count(parent, links)
    end
  end

  def transfers_between_you_and_santa(filename) do
    links = get_links(filename)

    you = ancestors("YOU", links)
    san = ancestors("SAN", links)

    common = common_ancestor(san, you)

    traversals_between_nodes(you, common) + traversals_between_nodes(san, common)
  end

  def ancestors(children, links) when is_list(children) do
    children
    |> Enum.reduce([], fn child, acc ->
      case child do
        [] -> acc
        _ ->
          ancs = ancestors(child, links)
          acc ++  ancs
      end
    end)
  end

  def ancestors(child, links) do
    parent =
      Enum.filter(links, fn [_p,c] -> c == child end)
      |> Enum.map(fn [p, _c] -> p end)

    case parent do
      [] -> []
      parent -> parent ++ ancestors(parent, links)
    end
  end

  def common_ancestor(san_ancs, you_ancs) do
    [head | _tail] = you_ancs -- (you_ancs -- san_ancs)
    head
  end

  def traversals_between_nodes(ancs, node) do
    ancs
    |> Enum.find_index(fn x -> x == node end)
  end

end
