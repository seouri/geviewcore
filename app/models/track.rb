class Track < ActiveRecord::Base
  def subtracks
    Track.where(:data_type => self.data_type).where("id < 990")
  end
end
