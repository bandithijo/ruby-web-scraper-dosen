class Dosen < ActiveRecord::Base
  validates :nama_dosen, presence: true
end
