defmodule Eagle do
  defmodule Tokenizer do
    use Behaviour
    defcallback tokenize(String) :: List
  end

  defmodule WordByWordTokenizer do
    @behaviour Tokenizer
    def tokenize(content) do
      String.split content
    end
  end

  defmodule Searcher do
    use Behaviour
    defcallback search(String) :: List
  end

  defmodule WordByWordSearcher do
    @behaviour Searcher
    def search(words) do
      tokens = WordByWordTokenizer.tokenize words
      titles = Enum.map tokens,
        fn token ->
          Agent.get :index, fn map -> Dict.get(map, token) end
        end
      uniq_titles = List.flatten titles
      |> Enum.uniq
      for title <- uniq_titles do
        Agent.get :contents, fn map -> Dict.get(map, title) end
      end
    end
  end

  def start_link do
    Agent.start_link fn -> Map.new end, name: :index
    Agent.start_link fn -> Map.new end, name: :contents
  end

  def add(title, content, tokenizer \\ "WordByWord") do
    tokens = case tokenizer do
      "WordByWord" -> WordByWordTokenizer.tokenize title <> " " <> content
      _ -> []
      end
    for token <- tokens do
      Agent.update :index,
        fn map ->
          case Dict.has_key? map, token do
            true ->
              value = Dict.get(map, token) ++ [title]
              Dict.put map, token, value
            false ->
              Dict.put map, token, [title]
          end
        end
    end
    Agent.update :contents,
      fn map ->
        Dict.put map, title, content
      end
  end

  def search(words, tokenizer \\ "WordByWord") do
    case tokenizer do
      "WordByWord" -> WordByWordSearcher.search words
      _ -> []
      end
  end
end

Eagle.start_link
Eagle.add "title1", "This is a content."
Eagle.add "title2", "This is another content."
IO.puts inspect Eagle.search "title1"
IO.puts inspect Eagle.search "another"
IO.puts inspect Eagle.search "This is"
