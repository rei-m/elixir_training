defmodule KV.Bucket.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  # 受け取ったsupervisorの子プロセスとしてbucketを開始する関数
  # KV.Bucket.start_linkの代わりに呼び出すようになる
  def start_bucket(supervisor) do
    # bucketの子プロセスのpidを返す
    Supervisor.start_child(supervisor, [])
  end

  def init(:ok) do
    # restart: :temporaryはbucektが死んでも自動で再開しないことを明示している。
    # bucketはregistryを通してのみ管理されるようにする = start_bucket でしか開始されない
    children = [
      worker(KV.Bucket, [], restart: :temporary)
    ]

    # :simple_one_for_one supervisorに動的にBucketのプロセスを追加していく
    supervise(children, strategy: :simple_one_for_one)
  end
end
