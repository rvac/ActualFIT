class Remark < ActiveRecord::Base
  attr_accessible :content, :inspection_id, :integer, :integer, :location, :remark_type, :string, :string, :string, :user_id
end
