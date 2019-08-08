class Task < ApplicationRecord
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

  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_conma

  belongs_to :user

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
