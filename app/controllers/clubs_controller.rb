class ClubsController < ApplicationController
  before_action :set_club, only: [ :show, :edit, :update, :destroy ]
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  # after_action :verify_authorized, only: [ :index ]

  def index
    if params[:query].present?
      @clubs = Club.search_by_name_and_description(params[:query])
    else
      @clubs = Club.all
    end
  end

  def show
    # @room = Room.find(params[:club_id])
    @club_membership = ClubMembership.new
  end

  private

  def set_club
    @club = Club.find(params[:id])
    authorize @club
  end
  def club_params
    params.require(:club).permit[:name, :description, :language, :cover_photo]
  end
end
