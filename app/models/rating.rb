class Rating < ActiveRecord::Base

  belongs_to :advice_session
  belongs_to :expert

  validates_presence_of :value

end
