defmodule Exql.Query do
  defstruct [
    pid: nil,
    sql: nil,
    params: [],
    scope: "*",
    rollup: :all,
    criteria: [],
    table: nil
  ]

  @doc """
  Outlines the table or view you want to query.

  Example:

  ```
  result =
    with_table("people")
    |> execute
  ```
  """
  def with_table(table) do
    %Exql.Query{table: table} |> build_sql
  end

  @doc """
  Specify that you want to return all rows from the query with a given scope.

  Example:

  ```
  result =
    with_table("people")
    |> all("name")
    |> execute
  ```
  """
  def all(query, columns \\ "*") do
    %{query | scope: columns, rollup: :all} |> build_sql
  end

  @doc """
  Specify that you want to return a single row from the query with the given scope.

  This will also apply a TOP 1 statement to the resulting SQL statement.

  Example:

  ```
  result =
    with_table("people")
    |> single("name")
    |> execute
  ```
  """
  def single(query, columns \\ "*") do
    %{query | scope: columns, rollup: :single} |> build_sql
  end

  @doc """
  Specify that you want to return the first row from the query with the given scope.

  This returns the full resultset and picks the first element from the list.

  Example:

  ```
  result =
    with_table("people")
    |> first("name")
    |> execute
  ```
  """
  def first(query, columns \\ "*") do
    %{query | scope: columns, rollup: :first} |> build_sql
  end

  @doc """
  Specify that you want to return the last row from the query with the given scope.

  This returns the full resultset and picks the last element from the list.

  Example:

  ```
  result =
    with_table("people")
    |> last("name")
    |> execute
  ```
  """
  def last(query, columns \\ "*") do
    %{query | scope: columns, rollup: :last} |> build_sql
  end

  @doc """
  Defines the where clause of your query.

  Example:

  ```
  result =
    with_table("people")
    |> filter("id = @id", [id: 1])
    |> execute
  ```
  """
  def filter(query, criteria, params) do
    %{query | criteria: query.criteria ++ [criteria], params: query.params ++ params} |> build_sql
  end

  @doc """
  Executes the SQL in a given SQL file without parameters. Specify the scripts directory by setting the `scripts` directive in the config.
  Pass the file name as an atom, without extension.
  ```
  result = sql_file(:simple)
  """
  def execute_sql_file(file) do
    file |> sql_file_command([]) |> execute_raw
  end

  @doc """
  Executes the SQL in a given SQL file with the specified parameters. Specify the scripts
  directory by setting the `scripts` directive in the config. Pass the file name as an atom,
  without extension.
  ```
  result = sql_file(:save_user, [1])
  ```
  """
  def execute_sql_file(file, params) do
    file |> sql_file_command(params) |> execute_raw
  end

  @doc """
  Creates a SQL File command
  """
  def sql_file_command(file, params \\ [])
  def sql_file_command(file, params) when not is_list(params),
    do: sql_file_command(file, [params])

  def sql_file_command(file, params) do
    scripts_dir = Application.get_env(:exql, :scripts)
    file_path = Path.join(scripts_dir, "#{Atom.to_string(file)}.sql")
    sql = File.read!(file_path)

    %Exql.Query{sql: String.strip(sql), params: params}
  end

  @doc """
  Wraps Exql.Sql.contruct/1 and adds resulting SQL to the Query.
  """
  def build_sql(query) do
    %{query | sql: query |> Exql.Sql.construct}
  end

  @doc """
  Connects to the database, executes the given query and returns the results.

  Example:

  ```
  result =
    with_table("people")
    |> execute
  ```
  """
  def execute(query) do
    Exql.Runner.connect!
    |> Exql.Runner.send_query(query)
  end

  def execute_raw(query) do
    Exql.Runner.connect!
    |> Exql.Runner.send_query_without_params(query)
  end

end
