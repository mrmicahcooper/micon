defmodule Micon.Svg do
  defstruct [:key, :filename, :filepath, :viewbox, :svg_paths]

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
    |> Stream.map(&generate(&1, source_dir))
    |> Stream.each(&insert/1)
    |> Stream.run()
  end

  defp generate(filepath, source_dir) do
    doc = File.read!(filepath) |> Floki.parse()
    key = Path.relative_to(filepath, source_dir) |> Path.dirname()
    filename = Path.basename(filepath, ".svg")
    viewbox = Floki.attribute(doc, "svg", "viewbox") |> List.first()

    svg_paths = doc
                |> Floki.find("g:first-child")
                |> Floki.attr("[fill]", "fill", fn(_) -> nil end)
                |> Floki.raw_html()

    %__MODULE__{
      key: key,
      filepath: filepath,
      filename: filename,
      viewbox: viewbox,
      svg_paths: svg_paths,
    }
  end

  defp insert(%{}=svg_data) do
    :ets.insert(@table_name, {svg_data.key, svg_data})
  end

end
