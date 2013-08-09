class CommandsController < ApplicationController
  before_action :authorize_admin

  def index
    @commands = Command.all
  end

  def show
  end

  def new
    @command = Command.new
  end

  def edit
  end

  def create
    binding.pry
    @command = Command.new(command_params)

    respond_to do |format|
      if @command.save
        format.html { redirect_to @command, notice: 'Command was successfully created.' }
        format.json { render action: 'show', status: :created, location: @command }
      else
        format.html { render action: 'new' }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @command.update(command_params)
        format.html { redirect_to @command, notice: 'Command was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @command.destroy
    respond_to do |format|
      format.html { redirect_to commands_url }
      format.json { head :no_content }
    end
  end

  private
  def authorize_admin
    #redirect_to root_path unless current_user.admin?
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def command_params
      params[:command]
    end
end
