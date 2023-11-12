class CommandsController < ApplicationController  
  
  def index
  end

  def show
  end
  
  def serve
    comm = Command.find_by_command(params[:command])
    if !comm.nil?
      date = comm.created_at
      day = date.day
      month = date.strftime("%B")
      year = date.year
      date_s = "#{month} #{day}, #{year}"

      # Different syntax for the same thing as in races_controller. Chose one (this is more like js)
      command = {
        command: comm.command,
        text: comm.text,
        author: comm.author,
        created: date_s
      }
    end
    render json: command
  end
  
end