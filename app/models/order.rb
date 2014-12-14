# coding: utf-8
class Order < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :apartment, touch: true
  
  has_many :line_items, dependent: :destroy
  
  validates :mobile, :apartment_id, :total_price, presence: true
  
  before_create :create_order_no
  def create_order_no
    self.order_no = Time.now.to_s(:number) + Time.now.nsec.to_s
  end
  
  def self.today_count
    self.today.count
  end
  
  state_machine initial: :normal do
    state :canceled
    state :completed
    
    event :cancel do
      transition :normal => :canceled
    end
    
    event :complete do
      transition :normal => :completed
    end
  end
  
  scope :today, -> { where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day) }
  scope :normal, -> { with_state(:normal) }
  scope :canceled, -> { with_state(:canceled) }
  scope :completed, -> { with_state(:completed) }
  
  def total_price
    self.quantity * product.origin_price
  end
  
  def self.search(keyword)
    if keyword.gsub(/\s+/, "").present?
      joins(:user, :product).where('orders.order_no like :keyword or users.mobile like :keyword or orders.deliver_address like :keyword or products.title like :keyword',{ keyword: "%#{keyword}%"})
    else
      all
    end
      
  end
  
end
