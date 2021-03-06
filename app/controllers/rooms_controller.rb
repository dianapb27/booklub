class RoomsController < ApplicationController
  # Loads:
  # @rooms = all rooms
  # @room = current room when applicable
  before_action :load_entities

  def index
    @club = Club.find(params[:club_id])
    @rooms = @club.rooms
    # current_user.clubs.each do |club|
    #   club.rooms.each do |room|
    #     @rooms << room
    #   end
    # end
    # @club = Club.find(params[:club_id])
    # @rooms = @club.rooms
  end

  def new
    @room = Room.new
    @club = Club.find(params[:club_id])
  end

  def show
    @club = Club.find(params[:club_id])
    @room = Room.find(params[:id])
    @room_message = RoomMessage.new room: @room
    @room_messages = @room.room_messages.includes(:user)
  end

  def create
    @room = Room.new permitted_parameters
    @club = Club.find(params[:club_id])
    @room.club = @club
    if @room.save
      flash[:success] = "Room #{@room.name} was created successfully"
      redirect_to club_room_path(@club, @room)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update_attributes(permitted_parameters)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  protected

  def load_entities
    @rooms = Room.all
    @room = Room.find(params[:id]) if params[:id]
  end

  def permitted_parameters
    params.require(:room).permit(:name)
  end
end
