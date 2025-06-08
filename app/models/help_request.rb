class HelpRequest < ApplicationRecord
  belongs_to :help_queue
  belongs_to :user
end
