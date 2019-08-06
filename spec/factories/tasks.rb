FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'テスト用データを準備する' }
    # 先ほど定義した:userという名前のFactoryを、Taskモデルに定義されたuserという名前の関連を生成するのに利用する
    user
  end
end