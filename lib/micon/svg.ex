defmodule Micon.Svg do
  use GenServer

  @table_name :icons

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    :ets.new(@table_name, [:bag, :named_table, write_concurrency: true])
    generate_svgs(opts.source_dir)
    {:ok, %{}}
  end

  def all do
    @table_name
    |> :ets.tab2list()
    |> Enum.map(&elem(&1, 1))
  end

  def get("/icons/") do
    @table_name
    |> :ets.lookup(".")
    |> Enum.map(&elem(&1, 1))
  end

  def get("/icons/"<>path) do
    @table_name
    |> :ets.lookup(path)
    |> Enum.map(&elem(&1, 1))
  end

  defp generate_svgs(source_dir) do
    source_dir
    |> Path.join("**/*.svg")
    |> Path.wildcard()
    |> Stream.map(&generate/1)
    |> Stream.each(&insert(&1, source_dir))
    |> Stream.run()
  end

  defp generate(file_path) do
    doc = File.read!(file_path) |> Floki.parse()
    filename = Path.basename(file_path, ".svg")
    viewbox = Floki.attribute(doc, "svg", "viewbox") |> List.first()
    svg_paths = doc
                |> Floki.find("g:first-child")
                |> Floki.attr("[fill]", "fill", fn(_) -> nil end)
                |> Floki.raw_html()

    %{
      file_path: file_path,
      filename: filename,
      viewbox: viewbox,
      svg_paths: svg_paths,
    }
  end

  defp insert(%{}=svg_data, source_dir) do
    key = svg_data.file_path
          |> Path.relative_to(source_dir)
          |> Path.dirname()

    :ets.insert(@table_name, {key, svg_data})
  end

end
