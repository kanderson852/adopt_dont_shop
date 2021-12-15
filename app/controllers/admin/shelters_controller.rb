class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.sort_reverse_alpha
    @shelters_pending = Shelter.pending_applications
  end
end
