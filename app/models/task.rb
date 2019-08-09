class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_conma

  belongs_to :user

  has_one_attached :image
  # コールバック関数の呼び出し
  # before_validation :set_nameless_name

  # 検索対象にするカラムを指定
  # ここで記載されてないカラムのパラメータが渡されても無視するようになる
  def self.ransackable_attributes(auth_object = nil)
    %w[name description created_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    []    
  end

  # CSV出力機能
  def self.csv_attributes
    ["name",  "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{|attr| task.send(attr)}
      end
    end
  end

  # CSV入力機能
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!  
    end
  end

  # カスタム用クエリメソッドの作成
  scope :recent, -> { order(created_at: :desc)}

    private
    def validate_name_not_including_conma
      errors.add(:name, 'にカンマを含めることはできないっすよ') if name&.include?(',')
    end

    # def set_nameless_name
    #   self.name = '名前なし' if name.blank?
    # end
end
